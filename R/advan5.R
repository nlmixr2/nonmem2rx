#' Handle the Ks for advan5/7 ode processing
#' @param k This is the detected K parameter
#' @return nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.advan5handleK <- function(k) {
  if (!(.nonmem2rx$advan %in% c(5L, 7L))) return(NULL)
  if (k %in% .nonmem2rx$advan5k) return(NULL)
  .reg1 <- "^[Kk]([1-9])[Tt]?([0-9])$"
  .reg2 <- "^[Kk]([1-9][0-9]*)[Tt]([0-9]+)$"
  if (grepl(.reg1, k)) {
    .n1 <- as.numeric(gsub(.reg1, "\\1", k))
    .n2 <- as.numeric(gsub(.reg1, "\\2", k))
  } else if (grepl(.reg2, k)) {
    .n1 <- as.numeric(gsub(.reg2, "\\1", k))
    .n2 <- as.numeric(gsub(.reg2, "\\2", k))
  } else {
    return(NULL)
  }
  .newMax <- max(.n1, .n2, .nonmem2rx$advan5max)
  if (.newMax > .nonmem2rx$advan5max) {
    .nonmem2rx$advan5 <- c(.nonmem2rx$advan5, rep("", .newMax - .nonmem2rx$advan5max))
    .nonmem2rx$advan5max <- .newMax
  }
  .nonmem2rx$advan5[.n1] <- paste0(.nonmem2rx$advan5[.n1], "-", k, "*rxddta", .n1)
  .pushObservedDadt(.n1)
  .setMaxA(.n1)
  if (.n2 != 0) {
    .nonmem2rx$advan5[.n2] <- paste0(.nonmem2rx$advan5[.n2], "+", k, "*rxddta", .n1)
    .pushObservedDadt(.n2)
    .setMaxA(.n2)
  }
  .nonmem2rx$advan5k <- c(.nonmem2rx$advan5k, k)
  # keep a clean directed edge (source, destination, rate constant name) so the
  # matrix-exponential path can rebuild the rate matrix; destination 0 means
  # elimination out of the system (rxode2 "output" compartment).  Only needed
  # for the matExp() translation, and accumulated in a list (materialized to a
  # data.frame once, in .advan5edgesDf()) to avoid repeated rbind() growth.
  if (isTRUE(.nonmem2rx$matexp)) {
    .nonmem2rx$advan5edges[[length(.nonmem2rx$advan5edges) + 1L]] <-
      list(from=.n1, to=.n2, k=k)
  }
  NULL
}
#' Materialize the accumulated ADVAN5/7 rate-constant edges as a data.frame
#'
#' @return data.frame with columns `from`, `to` (compartment indices; `to==0`
#'   is elimination) and `k` (rate-constant name), or `NULL` when none captured
#' @noRd
#' @author Matthew L. Fidler
.advan5edgesDf <- function() {
  .e <- .nonmem2rx$advan5edges
  if (length(.e) == 0L) return(NULL)
  data.frame(from=vapply(.e, `[[`, numeric(1), "from"),
             to=vapply(.e, `[[`, numeric(1), "to"),
             k=vapply(.e, `[[`, character(1), "k"),
             stringsAsFactors=FALSE)
}
#' Get the advan5 odes
#'  
#' @return advan5 odes if defined
#' @author Matthew L. Fidler
 #' @noRd
.advan5odes <- function() {
  if (!(.nonmem2rx$advan %in% c(5L, 7L))) return("")
  .w <- which(.nonmem2rx$advan5 == "")
  .ret <- paste0("d/dt(rxddta", seq_along(.nonmem2rx$advan5), ") <- ",
                 gsub("^[+]", "", .nonmem2rx$advan5))
  if (length(.w) > 0) .ret <- .ret[-.w]
  paste0("\n",paste(.ret, collapse="\n"))
}
#' Return the compartment name for a `d/dt()` model statement
#'
#' @param e language object (a single model statement)
#' @return the state name (character) for `d/dt(state) <- ...`, or `NA` otherwise
#' @noRd
#' @author Matthew L. Fidler
.ddtStateName <- function(e) {
  if (is.call(e) && (identical(e[[1]], quote(`<-`)) || identical(e[[1]], quote(`=`)))) {
    .lhs <- e[[2]]
    if (is.call(.lhs) && identical(.lhs[[1]], quote(`/`)) &&
          identical(.lhs[[2]], quote(d)) &&
          is.call(.lhs[[3]]) && identical(.lhs[[3]][[1]], quote(dt))) {
      return(deparse(.lhs[[3]][[2]]))
    }
  }
  NA_character_
}
#' Return the compartment name for a `cmt()` model statement
#'
#' @param e language object (a single model statement)
#' @return the compartment name (character) for `cmt(name)`, or `NA` otherwise
#' @noRd
#' @author Matthew L. Fidler
.cmtName <- function(e) {
  if (is.call(e) && identical(e[[1]], quote(cmt)) && length(e) == 2L) {
    return(deparse(e[[2]]))
  }
  NA_character_
}
#' Rewrite an ADVAN5/7 ode model as a matrix-exponential (matExp()) model
#'
#' The rate-constant graph captured by [.advan5handleK()] is emitted as rxode2's
#' native `matExp()` block (`cmt()` declarations plus `k_<from>_<to>` /
#' `k_<from>_output` rate constants), replacing the explicit `d/dt()` ODEs for
#' the linear system.  This must run on the finished, already-renamed ui so the
#' compartment names are final (see the note in nonmem2rx() about rxRename not
#' touching the `k_*` rate tokens).
#'
#' @param rxui finished rxode2 ui (ADVAN5/7 ode model, compartments already named)
#' @param finalNames ordered compartment names where `finalNames[i]` is the name
#'   of internal compartment `i`
#' @return the ui with the linear-system ODEs replaced by a `matExp()` block; the
#'   ui is returned unchanged when the model is not ADVAN5/7 or has no edges
#' @noRd
#' @author Matthew L. Fidler
.advan5matexp <- function(rxui, finalNames) {
  if (!(.nonmem2rx$advan %in% c(5L, 7L))) return(rxui)
  .edges <- .advan5edgesDf()
  if (is.null(.edges)) return(rxui)
  # matExp() is now the default translation, so degrade gracefully to the ODE
  # model if the installed rxode2 does not support matrix exponentials
  if (!exists("indLin", where=asNamespace("rxode2"), inherits=FALSE)) {
    warning("installed rxode2 does not support matrix exponentials (matExp()); ",
            "keeping the ADVAN5/7 ode translation", call.=FALSE)
    return(rxui)
  }
  # resolve each rate-constant name against the current model variables
  # case-insensitively; tolowerLhs (and other renaming) may have changed the
  # case seen while parsing $PK (e.g. K12 -> k12)
  .mv <- rxode2::rxModelVars(rxui)
  .vars <- c(.mv$lhs, .mv$params)
  .resolveK <- function(k) {
    .w <- which(tolower(.vars) == tolower(k))
    if (length(.w) >= 1L) .vars[.w[1L]] else k
  }
  .kLines <- vapply(seq_len(nrow(.edges)), function(i) {
    .from <- finalNames[.edges$from[i]]
    .to <- if (.edges$to[i] == 0L) "output" else finalNames[.edges$to[i]]
    sprintf("k_%s_%s <- %s", .from, .to, .resolveK(.edges$k[i]))
  }, character(1))
  .lines <- c("matExp()", paste0("cmt(", finalNames, ")"), .kLines)
  # drop the linear-system d/dt() and cmt() statements (the matExp block emits
  # its own cmt() declarations), keep everything else, and append the matExp
  # block
  .keep <- Filter(function(e) {
    .st <- .ddtStateName(e)
    if (!is.na(.st) && .st %in% finalNames) return(FALSE)
    .ct <- .cmtName(e)
    if (!is.na(.ct) && .ct %in% finalNames) return(FALSE)
    TRUE
  }, rxui$lstExpr)
  .new <- c(.keep, lapply(.lines, str2lang))
  model(rxui) <- bquote(model(.(as.call(c(quote(`{`), .new)))))
  rxui
}
