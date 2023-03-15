.rxnmRename1 <- function(rxui, lst) {
  .thetaMat <- rxui$thetaMat
  .dnt <- dimnames(.thetaMat)[[1]]
  .sigma <- rxui$sigma
  .dns <- dimnames(.sigma)[[1]]
  .w <- which(.dnt == lst[[4]])
  if (length(.w) == 1) {
    .dnt[.w] <- lst[[3]]
    dimnames(.thetaMat) <- list(.dnt, .dnt)
    rxui$thetaMat <- .thetaMat
  }
  .w <- which(.dns == lst[[4]])
  if (length(.w) == 1) {
    .dns[.w] <- lst[[3]]
    dimnames(.sigma) <- list(.dns, .dns)
    rxui$sigma <- .sigma
  }
}


#'@export
rxRename.nonmem2rx <- function(.data, ...) {
  .modelLines <- rxode2::.quoteCallInfoLines(match.call(expand.dots = TRUE)[-(1:2)])
  .lst <- as.list(match.call()[-1])
  .lst$.data <- .data
  .rxui <- do.call(rxode2::.rxRename, c(.lst, list(envir=parent.frame(2))))
  .lst <- lapply(seq_along(.modelLines), function(i) {
    rxode2::.assertRenameErrorModelLine(.modelLines[[i]], .vars)
  })
  ## now use call information to rename any other variables in `thetaMat` and `sigma`
  lapply(seq_along(.lst), function(i) {
    .rxnmRename1(.rxui, .lst[[i]])
  })
  rxode2::rxUiCompress(.rxui)
}

rename.nonmem2rx <- rxRename.nonmem2rx
