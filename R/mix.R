#' Interleave mixture component expressions with the probability names
#'
#' Builds the argument list for a `mix()` call from a vector of component
#' expressions and the probability parameter names, i.e. `E1, p1, E2, p2, ..., En`.
#'
#' @param components Character vector of length `nMix` with the component expressions
#' @param probNames Character vector of length `nMix - 1` with the probability names
#' @return Single string: the `mix(...)` call
#' @noRd
#' @author Matthew L. Fidler
.nonmemMixCall <- function(components, probNames) {
  .n <- length(components)
  .args <- character(0)
  for (.i in seq_len(.n - 1L)) {
    .args <- c(.args, components[.i], probNames[.i])
  }
  .args <- c(.args, components[.n])
  paste0("mix(", paste(.args, collapse = ", "), ")")
}

#' Collapse imperative MIXNUM/MIXEST branching into native mix() calls
#'
#' Rewrites the canonical NONMEM mixture idiom that assigns a single variable per
#' sub-population into a readable `mix()` call.  A "mixture group" for a variable
#' `V` is an optional leading default assignment `V <- E` (which pre-fills every
#' sub-population) followed by one or more consecutive `if (NMMIXNUM == k) V <- Ek`
#' overrides for the same `V`.  This covers both:
#'
#' * per-component `if`s: `if (NMMIXNUM == 1) V <- E1` ... `if (NMMIXNUM == n) V <- En`
#' * default + overrides: `V <- E1` then `if (NMMIXNUM == k) V <- Ek`
#'
#' Both collapse to `V <- mix(E1, p1, E2, ..., En)` once every sub-population has
#' an expression.  Lines that cannot be collapsed are returned unchanged (the
#' caller aliases the remaining `NMMIXNUM` references to the reserved `mixest`).
#'
#' @param lines Character vector of model lines (the mixture variable referenced
#'   as `NMMIXNUM`)
#' @param nMix Number of mixture sub-populations
#' @param probNames Character vector of length `nMix - 1` with the probability names
#' @return `list(lines=, emittedMix=)` where `emittedMix` is `TRUE` when at least
#'   one native `mix()` call was produced
#' @noRd
#' @author Matthew L. Fidler
.nonmemMixCollapse <- function(lines, nMix, probNames) {
  # some model elements bundle several statements joined by newlines (e.g. the
  # per-component cur.mixp `if`s); operate one statement per line
  lines <- unlist(strsplit(lines, "\n", fixed = TRUE))
  .ifRe <- "^if \\(NMMIXNUM == ([0-9]+)\\) ([A-Za-z0-9._]+) <- (.*)$"
  .asgnRe <- "^([A-Za-z0-9._]+) <- (.*)$"
  .out <- character(0)
  .emitted <- FALSE
  .i <- 1L
  .n <- length(lines)
  while (.i <= .n) {
    .line <- lines[.i]
    .collapsed <- FALSE
    # identify the variable and optional leading default for a mixture group
    .var <- NULL
    .comp <- rep(NA_character_, nMix)
    .j <- .i
    if (grepl(.asgnRe, .line) && !grepl("^if ", .line) && !grepl("<- mix\\(", .line)) {
      .var <- sub(.asgnRe, "\\1", .line)
      .comp[] <- sub(.asgnRe, "\\2", .line)  # default fills every sub-population
      .j <- .i + 1L
    } else if (grepl(.ifRe, .line)) {
      .var <- sub(.ifRe, "\\2", .line)
    }
    if (!is.null(.var)) {
      # consume consecutive per-component overrides for the same variable
      .nIf <- 0L
      while (.j <= .n && grepl(.ifRe, lines[.j]) && sub(.ifRe, "\\2", lines[.j]) == .var) {
        .num <- as.integer(sub(.ifRe, "\\1", lines[.j]))
        if (.num >= 1L && .num <= nMix) .comp[.num] <- sub(.ifRe, "\\3", lines[.j])
        .nIf <- .nIf + 1L
        .j <- .j + 1L
      }
      if (.nIf > 0L && !anyNA(.comp)) {
        .out <- c(.out, paste0(.var, " <- ", .nonmemMixCall(.comp, probNames)))
        .emitted <- TRUE
        .i <- .j
        .collapsed <- TRUE
      }
    }
    if (!.collapsed) {
      .out <- c(.out, .line)
      .i <- .i + 1L
    }
  }
  list(lines = .out, emittedMix = .emitted)
}

#' Finalize the mixture translation into native mix() model code
#'
#' Post-parse pass (run after all records, so `$PK`/`$PRED` code is available):
#' collapses collapsible MIXNUM/MIXEST branching into `mix()` calls, aliases any
#' remaining `NMMIXNUM` references to the reserved `mixest`, and drops the dummy
#' `mix()` / alias scaffolding once a real `mix()` call carries the probabilities.
#'
#' @return Nothing, mutates `.nonmem2rx$model`
#' @noRd
#' @author Matthew L. Fidler
.nonmem2rxMix <- function() {
  if (!isTRUE(.nonmem2rx$mixNative)) return(invisible(NULL))
  .probNames <- .nonmem2rx$mixProbNames
  .nMix <- .nonmem2rx$nspop
  .res <- .nonmemMixCollapse(.nonmem2rx$model, .nMix, .probNames)
  .lines <- .res$lines
  if (.res$emittedMix) {
    # a real mix() now registers the probabilities: the dummy call is redundant
    .lines <- .lines[!grepl("^rxMixDummy <- mix\\(", .lines)]
    # any leftover imperative branching keys off the reserved `mixest`
    .lines <- gsub("\\bNMMIXNUM\\b", "mixest", .lines)
    .lines <- .lines[!grepl("^mixest <- mixest$", .lines)]
  }
  assign("model", .lines, envir = .nonmem2rx)
  invisible(NULL)
}
