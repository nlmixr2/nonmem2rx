# This is built from buildParser.R, edit there
#'@export
rxSolve.nonmem2rx <- function(object, params = NULL, events = NULL, 
    inits = NULL, scale = NULL, method = c("liblsoda", "lsoda", 
        "dop853", "indLin"), sigdig = NULL, atol = 1e-08, rtol = 1e-06, 
    maxsteps = 70000L, hmin = 0, hmax = NA_real_, hmaxSd = 0, 
    hini = 0, maxordn = 12L, maxords = 5L, ..., cores, covsInterpolation = c("locf", 
        "linear", "nocb", "midpoint"), naInterpolation = c("locf", 
        "nocb"), addlKeepsCov = FALSE, addlDropSs = TRUE, ssAtDoseTime = TRUE, 
    safeZero = TRUE, safePow = TRUE, safeLog = TRUE, ss2cancelAllPending = FALSE, 
    nStud = 1L, dfSub = 0, dfObs = 0, thetaMat = NULL, ssAtol = 1e-08, 
    ssRtol = 1e-06, sigma = NULL, envir = parent.frame()) {
    if (missing(cores)) {
        cores <- 0L
    }
    if (missing(covsInterpolation)) {
        covsInterpolation <- "nocb"
        .minfo("using nocb interpolation like NONMEM, specify directly to change")
    }
    if (missing(addlKeepsCov)) {
        .minfo("using addlKeepsCov=TRUE like NONMEM, specify directly to change")
        addlKeepsCov <- TRUE
    }
    if (missing(addlDropSs)) {
        .minfo("using addlDropSs=TRUE like NONMEM, specify directly to change")
        addlDropSs <- TRUE
    }
    if (missing(ssAtDoseTime)) {
        .minfo("using ssAtDoseTime=TRUE like NONMEM, specify directly to change")
        ssAtDoseTime <- TRUE
    }
    if (missing(safeZero)) {
        .minfo("using safeZero=FALSE since NONMEM does not use protection by default")
        safeZero <- FALSE
    }
    if (missing(safePow)) {
        .minfo("using safePow=FALSE since NONMEM does not use protection by default")
        safePow <- FALSE
    }
    if (missing(safeLog)) {
        .minfo("using safeLog=FALSE since NONMEM does not use protection by default")
        safeLog <- FALSE
    }
    if (missing(ss2cancelAllPending)) {
        .minfo("using ss2cancelAllPending=FALSE since NONMEM does not cancel pending doses with SS=2")
        ss2cancelAllPending <- FALSE
    }
    if (!missing(nStud)) {
        if (missing(dfSub)) {
            if (!is.null(object$meta$dfSub)) {
                dfSub <- object$meta$dfSub
                .minfo(paste0("using dfSub=", dfSub, " from NONMEM"))
            }
            else if (!is.null(object$dfSub)) {
                dfSub <- object$dfSub
                .minfo(paste0("using dfSub=", dfSub, " from NONMEM"))
            }
        }
        if (missing(dfObs)) {
            if (!is.null(object$meta$dfObs)) {
                dfObs <- object$meta$dfObs
                .minfo(paste0("using dfObs=", dfObs, " from NONMEM"))
            }
            else if (!is.null(object$dfObs)) {
                dfObs <- object$dfObs
                dfObs <- object$meta$dfObs
                .minfo(paste0("using dfObs=", dfObs, " from NONMEM"))
            }
        }
        if (missing(thetaMat)) {
            if (!is.null(object$meta$thetaMat)) {
                thetaMat <- object$meta$thetaMat
                .minfo(paste0("using thetaMat from NONMEM"))
            }
            else if (!is.null(object$thetaMat)) {
                thetaMat <- object$meta$thetaMat
                .minfo(paste0("using thetaMat from NONMEM"))
            }
        }
    }
    if (missing(sigma)) {
        if (is.null(object$predDf)) {
            if (!is.null(object$meta$sigma)) {
                sigma <- object$meta$sigma
                .minfo(paste0("using sigma from NONMEM"))
            }
            else if (!is.null(object$sigma)) {
                sigma <- object$meta$sigma
                .minfo(paste0("using sigma from NONMEM"))
            }
        }
    }
    if ((missing(events) && missing(params))) {
        if (!is.null(object$nonmemData)) {
            events <- object$nonmemData
            .minfo(paste0("using NONMEM's data for solving"))
        }
    }
    if (missing(atol)) {
        if (!is.null(object$meta$atol)) {
            atol <- object$meta$atol
            .minfo(paste0("using NONMEM specified atol=", atol))
        }
        else if (!is.null(object$atol)) {
            atol <- object$atol
            .minfo(paste0("using NONMEM specified atol=", atol))
        }
    }
    if (missing(rtol)) {
        if (!is.null(object$meta$atol)) {
            rtol <- object$meta$rtol
            .minfo(paste0("using NONMEM specified rtol=", rtol))
        }
        else if (!is.null(object$atol)) {
            rtol <- object$rtol
            .minfo(paste0("using NONMEM specified rtol=", rtol))
        }
    }
    if (missing(ssRtol)) {
        if (!is.null(object$meta$ssRtol)) {
            ssRtol <- object$meta$ssRtol
            .minfo(paste0("using NONMEM specified ssRtol=", ssRtol))
        }
        else if (!is.null(object$meta$ssRtol)) {
            ssRtol <- object$meta$ssRtol
            .minfo(paste0("using NONMEM specified ssRtol=", ssRtol))
        }
    }
    if (missing(ssAtol)) {
        if (!is.null(object$meta$ssAtol)) {
            ssAtol <- object$meta$ssAtol
            .minfo(paste0("using NONMEM specified ssAtol=", ssAtol))
        }
        else if (!is.null(object$ssAtol)) {
            ssAtol <- object$ssAtol
            .minfo(paste0("using NONMEM specified ssAtol=", ssAtol))
        }
    }
    .cls <- class(object)
    class(object) <- .cls[-which(.cls == "nonmem2rx")]
    rxode2::rxSolve(object = object, params = params, events = events, 
        inits = inits, scale = scale, method = method, sigdig = sigdig, 
        atol = atol, rtol = rtol, maxsteps = maxsteps, hmin = hmin, 
        hmax = hmax, hmaxSd = hmaxSd, hini = hini, maxordn = maxordn, 
        maxords = maxords, ..., cores = cores, covsInterpolation = covsInterpolation, 
        addlKeepsCov = addlKeepsCov, addlDropSs = addlDropSs, 
        ssAtDoseTime = ssAtDoseTime, safeZero = safeZero, safePow = safePow, 
        safeLog = safeLog, ss2cancelAllPending = ss2cancelAllPending, 
        nStud = nStud, dfSub = dfSub, dfObs = dfObs, thetaMat = thetaMat, 
        ssAtol = ssAtol, ssRtol = ssRtol, sigma = sigma, envir = envir)
}
