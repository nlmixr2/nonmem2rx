#' Convert a model to a nonmem2rx model
#'
#' @param model1 Input model 1
#' @param model2 Input model 2
#' @param compress boolean to compress the ui at the end
#' @return nonmem2rx model
#' @export
#' @author Matthew L. Fidler
#' @examples
#'
#' \donttest{
#'
#'  mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
#'                   determineError=FALSE, lst=".res", save=FALSE)
#'
#'  mod2 <-function() {
#'    ini({
#'      lcl <- 1.37034036528946
#'      lvc <- 4.19814911033061
#'      lq <- 1.38003493562413
#'      lvp <- 3.87657341967489
#'      RSV <- c(0, 0.196446108190896, 1)
#'      eta.cl ~ 0.101251418415006
#'      eta.v ~ 0.0993872449483344
#'      eta.q ~ 0.101302674763154
#'      eta.v2 ~ 0.0730497519364148
#'    })
#'    model({
#'      cmt(CENTRAL)
#'      cmt(PERI)
#'      cl <- exp(lcl + eta.cl)
#'      v <- exp(lvc + eta.v)
#'      q <- exp(lq + eta.q)
#'      v2 <- exp(lvp + eta.v2)
#'      v1 <- v
#'      scale1 <- v
#'      k21 <- q/v2
#'      k12 <- q/v
#'      d/dt(CENTRAL) <- k21 * PERI - k12 * CENTRAL - cl * CENTRAL/v1
#'      d/dt(PERI) <- -k21 * PERI + k12 * CENTRAL
#'      f <- CENTRAL/scale1
#'      f ~ prop(RSV)
#'    })
#'  }
#'
#' new <- try(as.nonmem2rx(mod2, mod))
#' if (!inherits(new, "try-error")) print(new, page=1)
#'
#' }
#'
as.nonmem2rx <- function(model1, model2, compress=TRUE) {
  if (inherits(model1, "nonmem2rx")) {
    .nm2rx <- model1
    if (inherits(model2, "nonmem2rx")) stop("it makes no sense to have 2 nonmem2rx models", call.=FALSE)
    .ui <- rxode2::as.rxUi(model2)
  } else if (inherits(model2, "nonmem2rx")) {
    .nm2rx <- model2
    .ui <- rxode2::as.rxUi(model1)
  }
  if (is.null(.ui$predDf)) {
    stop("This only tries to convert to a rxode2 model with residual specification\nthis model is missing residual specification",
         call.=FALSE)
  }
  .rx <- rxode2::rxUiDecompress(.ui)
  .nm2rx <- rxode2::rxUiDecompress(.nm2rx)
  .cp <- c("sticky", "nonmemData", "atol", "rtol", "ssAtol", "ssRtol", "etaData",
           "ipredData", "predData", "sigmaNames", "dfSub", "thetaMat", "dfObs",
           "file", "outputExtension")
  .meta <- new.env(parent=emptyenv())
  if (exists("meta", envir=.nm2rx)) {
    .meta <- get("meta", envir=.nm2rx)
  }
  .metaRx <- new.env(parent=emptyenv())
  if (exists("meta", envir=.rx)) {
    .metaRx <- get("meta", envir=.rx)
  }
  lapply(.cp, function(x) {
    if (exists(x, envir=.nm2rx)) {
      assign(x, get(x, envir=.nm2rx), envir=.rx)
    }
    if (exists(x, envir=.meta) && !exists(x, envir=.metaRx)) {
      .minfo(paste0("copy '", x, "' to nonmem2rx model"))
      assign(x, get(x, envir=.meta), envir=.metaRx)
    }
  })
  .nonmemData <- .rx$nonmemData
  .w <- which(names(.nonmemData) == "nmdvid")
  if (length(.w) == 1L) {
    .wcmt <- which(tolower(names(.nonmemData)) == "cmt")
    .wevid <- which(tolower(names(.nonmemData)) == "evid")
    if (length(.wcmt) == 1L && length(.wevid) == 1L) {
      .minfo("merging 'dvid' with nlmixr2 'cmt' definition")
      .nonmemData[,.wcmt] <- ifelse(.nonmemData[, .wevid] != 0, .nonmemData[,.wcmt],
                                    length(.ui$mv0$state) + .nonmemData[, .w])
      .rx$nonmemData <- .nonmemData
    } else {
      .minfo("assuming 'dvid' is close enough to nlmixr2 definition")
      names(.nonmemData)[.w] <- "dvid"
    }

  }
  # now rename thetaMat
  .iniDfIn <- .nm2rx$iniDf
  .iniDfOut <- .rx$iniDf
  .getNewName <- function(x, id=FALSE) {
    if (id && tolower(x) == "id") return(x)
    .w <- which(.iniDfIn$name == x)
    if (length(.w) == 1) {
      .est <- .iniDfIn$est[.w]
      .w <- which(abs(.iniDfOut$est - .est) < 1e-6)
      if (length(.w) == 1) {
        return(.iniDfOut$name[.w])
      }
    }
    "..drop.."
  }
  names(.rx$etaData) <- vapply(names(.rx$etaData), .getNewName, character(1), id=TRUE,
                               USE.NAMES=FALSE)
  if (any(names(.rx$etaData) == "..drop..")) {
    stop("cannot determine eta translation, need parameter estimates to match",
         call.=FALSE)
  }
  .thetaMat <- .rx$thetaMat
  if (!is.null(.thetaMat)) {
    .dn <- vapply(dimnames(.thetaMat)[[1]], .getNewName, character(1), USE.NAMES=FALSE)
    .thetaMat <- .rx$thetaMat
    dimnames(.thetaMat) <- list(.dn, .dn)
    .w <- which(.dn == "..drop..")
    .thetaMat <- .thetaMat[-.w, -.w]
    .ndim <- dim(.rx$omega)[1] + length(.rx$theta)
    if (dim(.thetaMat)[1] != .ndim) {
      warning("not all the initial estimates matched in the model, check model",
              call.=FALSE)
    }
  }
  .msg <- .nonmem2rxValidate(.rx, msg=NULL, validate=TRUE, ci=0.95, sigdig=3)
  if (is.null(.rx$predAtol)) {
    stop("validation failed, this does not match the prior model",
         call.=FALSE)
  }
  if (!is.null(.msg)) {
    .rx$meta$validation <- .msg
  }
  if (length(.nonmem2rx$modelDesc) > 0) {
    .rx$meta$description <- .nm2rx$meta$description
  }
  if (exists("thetaMat", .rx$meta)) {
    assign("thetaMat", .thetaMat, envir=.rx$meta)
  } else {
    assign("thetaMat", .thetaMat, envir=.rx)
  }
  if (compress) {
    .ret <- rxode2::rxUiCompress(.rx)
  } else {
    .ret <- .rx
  }
  class(.ret) <- c("nonmem2rx", class(.ret))
  .ret
}
