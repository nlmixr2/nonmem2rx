.rxnmRename1 <- function(rxui, lst) {
  .doThetaMatMeta <- FALSE
  if (exists("thetaMat", envir=rxui$meta)) {
    .thetaMat <- rxui$meta$thetaMat
    .doThetaMatMeta <- TRUE
  } else {
    .thetaMat <- rxui$thetaMat
  }
  .dnt <- dimnames(.thetaMat)[[1]]
  .doSigmaMeta <- FALSE
  if (exists("sigma", envir=rxui$meta)) {
    .sigma <- rxui$meta$sigma
    .doSigmaMeta <- TRUE
  } else {
    .sigma <- rxui$sigma
  }
  .dns <- dimnames(.sigma)[[1]]
  .w <- which(.dnt == lst[[4]])
  if (length(.w) == 1) {
    .dnt[.w] <- lst[[3]]
    dimnames(.thetaMat) <- list(.dnt, .dnt)
    if (.doThetaMatMeta) {
      rxui$meta$thetaMat <- .thetaMat
    } else {
      rxui$thetaMat <- .thetaMat
    }
  }
  .w <- which(.dns == lst[[4]])
  if (length(.w) == 1) {
    .dns[.w] <- lst[[3]]
    dimnames(.sigma) <- list(.dns, .dns)
    if (.doSigmaMeta) {
      rxui$meta$sigma <- .sigma
    } else {
      rxui$sigma <- .sigma
    }
  }
}

#'@export
rxRename.nonmem2rx <- function(.data, ...) {
  .modelLines <- rxode2::.quoteCallInfoLines(match.call(expand.dots = TRUE)[-(1:2)])
  .lst0 <- as.list(match.call()[-1])
  .lst0$.data <- .data
  .vars <- unique(c(.data$mv0$state, .data$mv0$params, .data$mv0$lhs, .data$predDf$var, .data$predDf$cond, .data$iniDf$name))
  .lst <- lapply(seq_along(.modelLines), function(i) {
    rxode2::.assertRenameErrorModelLine(.modelLines[[i]], .vars)
  })
  .rxui <- rxode2::rxUiDecompress(do.call(rxode2::.rxRename, c(.lst0, list(envir=parent.frame(2)))))
  ## now use call information to rename any other variables in `thetaMat` and `sigma`
  lapply(seq_along(.lst), function(i) {
    .rxnmRename1(.rxui, .lst[[i]])
  })
  .ret <- rxode2::rxUiCompress(.rxui)
  if (!inherits(.ret, "nonmem2x")) {
    class(.ret) <- c("nonmem2rx", class(.ret))
  }
  .ret
}

rename.nonmem2rx <- rxRename.nonmem2rx
