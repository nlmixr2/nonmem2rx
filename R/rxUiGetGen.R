## nocov start
# This is built from buildParser.R, edit there

rxUiGet.nonmemData <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("nonmemData", envir=.meta)) return(get("nonmemData", envir=.meta))
  if (!exists("nonmemData", envir=x[[1]])) return(NULL)
  get("nonmemData", envir=x[[1]])
}
attr(rxUiGet.nonmemData, "desc=") <- "NONMEM input data from nonmem2rx"

rxUiGet.etaData <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("etaData", envir=.meta)) return(get("etaData", envir=.meta))
  if (!exists("etaData", envir=x[[1]])) return(NULL)
  get("etaData", envir=x[[1]])
}
attr(rxUiGet.etaData, "desc=") <- "NONMEM etas input from nonmem2rx"

rxUiGet.ipredAtol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("ipredAtol", envir=.meta)) return(get("ipredAtol", envir=.meta))
  if (!exists("ipredAtol", envir=x[[1]])) return(NULL)
  get("ipredAtol", envir=x[[1]])
}
attr(rxUiGet.ipredAtol, "desc=") <- "50th percentile of the IPRED atol comparison between rxode2 and model import"

rxUiGet.ipredRtol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("ipredRtol", envir=.meta)) return(get("ipredRtol", envir=.meta))
  if (!exists("ipredRtol", envir=x[[1]])) return(NULL)
  get("ipredRtol", envir=x[[1]])
}
attr(rxUiGet.ipredRtol, "desc=") <- "50th percentile of the IPRED rtol comparison between rxode2 and model import"

rxUiGet.ipredCompare <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("ipredCompare", envir=.meta)) return(get("ipredCompare", envir=.meta))
  if (!exists("ipredCompare", envir=x[[1]])) return(NULL)
  get("ipredCompare", envir=x[[1]])
}
attr(rxUiGet.ipredCompare, "desc=") <- "Dataset comparing ID, TIME and the IPREDs between rxode2 and model import"

rxUiGet.predAtol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("predAtol", envir=.meta)) return(get("predAtol", envir=.meta))
  if (!exists("predAtol", envir=x[[1]])) return(NULL)
  get("predAtol", envir=x[[1]])
}
attr(rxUiGet.predAtol, "desc=") <- "50th percentile of the PRED atol comparison between rxode2 and model import"

rxUiGet.predRtol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("predRtol", envir=.meta)) return(get("predRtol", envir=.meta))
  if (!exists("predRtol", envir=x[[1]])) return(NULL)
  get("predRtol", envir=x[[1]])
}
attr(rxUiGet.predRtol, "desc=") <- "50th percentile of the PRED rtol comparison between rxode2 and model import"

rxUiGet.predCompare <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("predCompare", envir=.meta)) return(get("predCompare", envir=.meta))
  if (!exists("predCompare", envir=x[[1]])) return(NULL)
  get("predCompare", envir=x[[1]])
}
attr(rxUiGet.predCompare, "desc=") <- "Dataset comparing ID, TIME and the PREDs between rxode2 and model import"

rxUiGet.sigma <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("sigma", envir=.meta)) return(get("sigma", envir=.meta))
  if (!exists("sigma", envir=x[[1]])) return(NULL)
  get("sigma", envir=x[[1]])
}
attr(rxUiGet.sigma, "desc=") <- "sigma matrix from model import"

rxUiGet.thetaMat <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("thetaMat", envir=.meta)) return(get("thetaMat", envir=.meta))
  if (!exists("thetaMat", envir=x[[1]])) return(NULL)
  get("thetaMat", envir=x[[1]])
}
attr(rxUiGet.thetaMat, "desc=") <- "covariance matrix"

rxUiGet.dfSub <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("dfSub", envir=.meta)) return(get("dfSub", envir=.meta))
  if (!exists("dfSub", envir=x[[1]])) return(NULL)
  get("dfSub", envir=x[[1]])
}
attr(rxUiGet.dfSub, "desc=") <- "Number of subjects"

rxUiGet.dfObs <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("dfObs", envir=.meta)) return(get("dfObs", envir=.meta))
  if (!exists("dfObs", envir=x[[1]])) return(NULL)
  get("dfObs", envir=x[[1]])
}
attr(rxUiGet.dfObs, "desc=") <- "Number of observations"

rxUiGet.atol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("atol", envir=.meta)) return(get("atol", envir=.meta))
  if (!exists("atol", envir=x[[1]])) return(NULL)
  get("atol", envir=x[[1]])
}
attr(rxUiGet.atol, "desc=") <- "atol imported from translation"

rxUiGet.rtol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("rtol", envir=.meta)) return(get("rtol", envir=.meta))
  if (!exists("rtol", envir=x[[1]])) return(NULL)
  get("rtol", envir=x[[1]])
}
attr(rxUiGet.rtol, "desc=") <- "rtol imported from translation"

rxUiGet.ssRtol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("ssRtol", envir=.meta)) return(get("ssRtol", envir=.meta))
  if (!exists("ssRtol", envir=x[[1]])) return(NULL)
  get("ssRtol", envir=x[[1]])
}
attr(rxUiGet.ssRtol, "desc=") <- "ssRtol imported from translation"

rxUiGet.ssAtol <- function(x, ...) {
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=x[[1]])) .meta <- get("meta", envir=x[[1]])
  if (exists("ssAtol", envir=.meta)) return(get("ssAtol", envir=.meta))
  if (!exists("ssAtol", envir=x[[1]])) return(NULL)
  get("ssAtol", envir=x[[1]])
}
attr(rxUiGet.ssAtol, "desc=") <- "ssRtol imported from translation"
.rxUiGetRegister <- function() {
  rxode2::.s3register("rxode2::rxUiGet", "nonmemData")
  rxode2::.s3register("rxode2::rxUiGet", "etaData")
  rxode2::.s3register("rxode2::rxUiGet", "ipredAtol")
  rxode2::.s3register("rxode2::rxUiGet", "ipredRtol")
  rxode2::.s3register("rxode2::rxUiGet", "ipredCompare")
  rxode2::.s3register("rxode2::rxUiGet", "predAtol")
  rxode2::.s3register("rxode2::rxUiGet", "predRtol")
  rxode2::.s3register("rxode2::rxUiGet", "predCompare")
  rxode2::.s3register("rxode2::rxUiGet", "sigma")
  rxode2::.s3register("rxode2::rxUiGet", "thetaMat")
  rxode2::.s3register("rxode2::rxUiGet", "dfSub")
  rxode2::.s3register("rxode2::rxUiGet", "dfObs")
  rxode2::.s3register("rxode2::rxUiGet", "atol")
  rxode2::.s3register("rxode2::rxUiGet", "rtol")
  rxode2::.s3register("rxode2::rxUiGet", "ssRtol")
  rxode2::.s3register("rxode2::rxUiGet", "ssAtol")
}
## nocov end
