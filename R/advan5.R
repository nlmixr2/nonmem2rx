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
  if (.n2 != 0) .nonmem2rx$advan5[.n2] <- paste0(.nonmem2rx$advan5[.n2], "+", k, "*rxddta", .n1)
  .nonmem2rx$advan5k <- c(.nonmem2rx$advan5k, k)
  NULL
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
