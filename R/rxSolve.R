# This is built from buildParser.R, edit there
#'@export
rxSolve.nonmem2rx <- function(object, params = NULL, events = NULL, 
    inits = NULL, scale = NULL, method = c("liblsoda", "lsoda", 
        "dop853", "indLin"), sigdig = NULL, atol = 1e-08, rtol = 1e-06, 
    maxsteps = 70000L, hmin = 0, hmax = NA_real_, hmaxSd = 0, 
    hini = 0, maxordn = 12L, maxords = 5L, ..., cores, covsInterpolation = c("locf", 
        "linear", "nocb", "midpoint"), addCov = TRUE, sigma = NULL, 
    sigmaDf = NULL, sigmaLower = -Inf, sigmaUpper = Inf, nCoresRV = 1L, 
    sigmaIsChol = FALSE, sigmaSeparation = c("auto", "lkj", "separation"), 
    sigmaXform = c("identity", "variance", "log", "nlmixrSqrt", 
        "nlmixrLog", "nlmixrIdentity"), nDisplayProgress = 10000L, 
    amountUnits = NA_character_, timeUnits = "hours", theta = NULL, 
    thetaLower = -Inf, thetaUpper = Inf, eta = NULL, addDosing = FALSE, 
    stateTrim = Inf, updateObject = FALSE, omega = NULL, omegaDf = NULL, 
    omegaIsChol = FALSE, omegaSeparation = c("auto", "lkj", "separation"), 
    omegaXform = c("variance", "identity", "log", "nlmixrSqrt", 
        "nlmixrLog", "nlmixrIdentity"), omegaLower = -Inf, omegaUpper = Inf, 
    nSub = 1L, thetaMat = NULL, thetaDf = NULL, thetaIsChol = FALSE, 
    nStud = 1L, dfSub = 0, dfObs = 0, returnType = c("rxSolve", 
        "matrix", "data.frame", "data.frame.TBS", "data.table", 
        "tbl", "tibble"), seed = NULL, nsim = NULL, minSS = 10L, 
    maxSS = 1000L, infSSstep = 12, strictSS = TRUE, istateReset = TRUE, 
    subsetNonmem = TRUE, maxAtolRtolFactor = 0.1, from = NULL, 
    to = NULL, by = NULL, length.out = NULL, iCov = NULL, keep = NULL, 
    indLinPhiTol = 1e-07, indLinPhiM = 0L, indLinMatExpType = c("expokit", 
        "Al-Mohy", "arma"), indLinMatExpOrder = 6L, drop = NULL, 
    idFactor = TRUE, mxhnil = 0, hmxi = 0, warnIdSort = TRUE, 
    warnDrop = TRUE, ssAtol = 1e-08, ssRtol = 1e-06, safeZero = TRUE, 
    sumType = c("pairwise", "fsum", "kahan", "neumaier", "c"), 
    prodType = c("long double", "double", "logify"), sensType = c("advan", 
        "autodiff", "forward", "central"), linDiff = c(tlag = 1.5e-05, 
        f = 1.5e-05, rate = 1.5e-05, dur = 1.5e-05, tlag2 = 1.5e-05, 
        f2 = 1.5e-05, rate2 = 1.5e-05, dur2 = 1.5e-05), linDiffCentral = c(tlag = TRUE, 
        f = TRUE, rate = TRUE, dur = TRUE, tlag2 = TRUE, f2 = TRUE, 
        rate2 = TRUE, dur2 = TRUE), resample = NULL, resampleID = TRUE, 
    maxwhile = 1e+05, atolSens = 1e-08, rtolSens = 1e-06, ssAtolSens = 1e-08, 
    ssRtolSens = 1e-06, simVariability = NA, nLlikAlloc = NULL, 
    useStdPow = FALSE) {
    if (missing(covsInterpolation)) {
        covsInterpolation <- "nocb"
        .minfo("using nocb interpolation like NONMEM, specify directly to change")
    }
    if (missing(dfSub)) {
        if (!is.null(object$dfSub)) {
            dfSub <- object$dfSub
            .minfo(paste0("using dfSub=", dfSub, " from NONMEM"))
        }
    }
    if (missing(dfObs)) {
        if (!is.null(object$dfObs)) {
            dfSub <- object$dfObs
            .minfo(paste0("using dfObs=", dfObs, " from NONMEM"))
        }
    }
    if (missing(thetaMat)) {
        if (!is.null(object$thetaMat)) {
            dfSub <- object$dfObs
            .minfo(paste0("using thetaMat from NONMEM"))
        }
    }
    if (missing(sigma)) {
        if (!is.null(object$thetaMat)) {
            omega <- object$omega
            .minfo(paste0("using sigma from NONMEM"))
        }
    }
    if ((missing(events) && missing(params))) {
        if (!is.null(object$nonmemData)) {
            events <- object$nonmemData
            .minfo(paste0("using NONMEM's data for solving"))
        }
    }
    .cls <- class(object)
    class(object) <- .cls[-which(.cls == "nonmem2rx")]
    rxode2::rxSolve(object = object, params = params, events = events, 
        inits = inits, scale = scale, method = method, sigdig = sigdig, 
        atol = atol, rtol = rtol, maxsteps = maxsteps, hmin = hmin, 
        hmax = hmax, hmaxSd = hmaxSd, hini = hini, maxordn = maxordn, 
        maxords = maxords, ..., cores = cores, covsInterpolation = covsInterpolation, 
        addCov = addCov, sigma = sigma, sigmaDf = sigmaDf, sigmaLower = sigmaLower, 
        sigmaUpper = sigmaUpper, nCoresRV = nCoresRV, sigmaIsChol = sigmaIsChol, 
        sigmaSeparation = sigmaSeparation, sigmaXform = sigmaXform, 
        nDisplayProgress = nDisplayProgress, amountUnits = amountUnits, 
        timeUnits = timeUnits, theta = theta, thetaLower = thetaLower, 
        thetaUpper = thetaUpper, eta = eta, addDosing = addDosing, 
        stateTrim = stateTrim, updateObject = updateObject, omega = omega, 
        omegaDf = omegaDf, omegaIsChol = omegaIsChol, omegaSeparation = omegaSeparation, 
        omegaXform = omegaXform, omegaLower = omegaLower, omegaUpper = omegaUpper, 
        nSub = nSub, thetaMat = thetaMat, thetaDf = thetaDf, 
        thetaIsChol = thetaIsChol, nStud = nStud, dfSub = dfSub, 
        dfObs = dfObs, returnType = returnType, seed = seed, 
        nsim = nsim, minSS = minSS, maxSS = maxSS, infSSstep = infSSstep, 
        strictSS = strictSS, istateReset = istateReset, subsetNonmem = subsetNonmem, 
        maxAtolRtolFactor = maxAtolRtolFactor, from = from, to = to, 
        by = by, length.out = length.out, iCov = iCov, keep = keep, 
        indLinPhiTol = indLinPhiTol, indLinPhiM = indLinPhiM, 
        indLinMatExpType = indLinMatExpType, indLinMatExpOrder = indLinMatExpOrder, 
        drop = drop, idFactor = idFactor, mxhnil = mxhnil, hmxi = hmxi, 
        warnIdSort = warnIdSort, warnDrop = warnDrop, ssAtol = ssAtol, 
        ssRtol = ssRtol, safeZero = safeZero, sumType = sumType, 
        prodType = prodType, sensType = sensType, linDiff = linDiff, 
        linDiffCentral = linDiffCentral, resample = resample, 
        resampleID = resampleID, maxwhile = maxwhile, atolSens = atolSens, 
        rtolSens = rtolSens, ssAtolSens = ssAtolSens, ssRtolSens = ssRtolSens, 
        simVariability = simVariability, nLlikAlloc = nLlikAlloc, 
        useStdPow = useStdPow)
}
