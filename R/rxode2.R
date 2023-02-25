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

.dressAndSaveObj <- function(x, env) {
  .new <- rxode2::rxUiDecompress(x)
  for (.v in .nonmem2rxExtraSave) {
    if (exists(.v, envir=env)) {
      assign(.v, get(.v, envir=env), envir=.new)
    }
  }
  .new <- rxode2::rxUiCompress(.new)
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

