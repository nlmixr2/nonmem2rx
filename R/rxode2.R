.nonmem2rxExtraSave <- c("nonmemData", "etaData", "ipredAtol", "ipredRtol",
                         "ipredCompare", "predAtol", "predRtol", "predCompare",
                         "sigma", "thetaMat", "dfSub", "dfObs")

.stripAndSaveObj <- function(x) {
  .env <- new.env(parent=emptyenv())
  .x <- x
  .clsX <- class(.x)
  .clsX <- .clsX[-which(.clsX == "nonmem2rx")]
  class(.x) <- .clsX
  .x <- rxode2::rxUiDecompress(.x)
  for (.v in .nonmem2rxExtraSave) {
    if (exists(.v, envir=.x)) {
      assign(.v, get(.v, envir=.x), envir=.env)
    }
  }
  list(.env, .x)
}

.dressAndSaveObj <- function(x, env, compress=TRUE) {
  .new <- rxode2::rxUiDecompress(x)
  for (.v in .nonmem2rxExtraSave) {
    if (exists(.v, envir=env)) {
      assign(.v, get(.v, envir=env), envir=.new)
    }
  }
  if (compress) .new <- rxode2::rxUiCompress(.new)
  class(.new) <- c("nonmem2rx", class(.new))
  .new
}


#'@export
ini.nonmem2rx <- function(x, ..., envir = parent.frame(), append = NULL) {
  # save information from the nonmem2rx
  .tmp <- .stripAndSaveObj(x)
  .ret <- .tmp[[2]]
  .iniDf <- .ret$iniDf
  .iniLines <- rxode2::.quoteCallInfoLines(match.call(expand.dots = TRUE)[-(1:2)], 
                                           envir = envir, iniDf = .iniDf)
  lapply(.iniLines, function(line) {
    rxode2::.iniHandleLine(expr = line, rxui = .ret, envir = envir, 
                           append = append)
  })
  .dressAndSaveObj(.ret, .tmp[[1]])
}


#'@export
model.nonmem2rx <- function(x, ..., append = FALSE,
                            auto = getOption("rxode2.autoVarPiping", TRUE),
                            envir = parent.frame()) {
  # save information from the nonmem2rx
  .tmp <- .stripAndSaveObj(x)
  .ret <- .tmp[[2]]
  .modelLines <- rxode2::.quoteCallInfoLines(match.call(expand.dots = TRUE)[-(1:2)], 
                                             envir = envir)
  rxode2::.modelHandleModelLines(.modelLines, .ret, modifyIni = FALSE, 
                                 append = append, auto = auto, envir = envir)
  .dressAndSaveObj(.ret, .tmp[[1]])
}


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
  .lst <- as.list(match.call()[-1])
  .modelLines <- rxode2::.quoteCallInfoLines(match.call(expand.dots = TRUE)[-(1:2)])
  .tmp <- .stripAndSaveObj(.data)
  .lst$.data <- .tmp[[2]]
  .rxui <- .tmp[[2]]
  .vars <- unique(c(.rxui$mv0$state, .rxui$mv0$params, .rxui$mv0$lhs, .rxui$predDf$var, .rxui$predDf$cond, .rxui$iniDf$name))
  .rxui <- .dressAndSaveObj(do.call(rxode2::.rxRename, c(.lst, list(envir = parent.frame(2)))),
                            .tmp[[1]], compress=FALSE)
  .lst <- lapply(seq_along(.modelLines), function(i) {
    rxode2::.assertRenameErrorModelLine(.modelLines[[i]], .vars)
  })
  ## now use call information to rename any other variables in `thetaMat` and `sigma`
  lapply(seq_along(.lst), function(i) {
    .rxnmRename1(.rxui, .lst[[i]])
  })
  rxode2::rxUiCompress(.rxui)
}

