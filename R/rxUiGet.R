rxUiGet.simulationModelIwres <- function(x, ...) {
  .ui <- x[[1]]
  if (is.null(.ui$predDf)) {
    .ui$simulationModel
  } else {
    .ns <- loadNamespace("rxode2")
    .env <- new.env(parent=.ns)
    .env$.ui <- .ui
    .ui <- with(.env,eval(rxode2::rxCombineErrorLines(.ui, modelVars=TRUE)))
    DV <- sim <- iwres <- rxdv <- rx_pred_ <- rx_r_ <- NULL
    if (length(.ui$predDf$cond) == 1) {
      .ret <- suppressMessages(rxode2::model(.ui, iwres <- (DV-rx_pred_)/sqrt(rx_r_),
                                             append=sim, auto=FALSE))
    } else {
      .ret <- suppressMessages(rxode2::as.rxUi(.ui))
      .lstExpr <- .ret$lstExpr
      .l <- length(.lstExpr)
      while(identical(.lstExpr[[.l]][[1]], quote(`dvid`)) ||
              identical(.lstExpr[[.l]][[1]], quote(`cmt`))) .l <- .l - 1
      .lstOut <- c(list(quote(`{`)),
                   lapply(seq_len(.l), function(i) .lstExpr[[i]]),
                    list(quote(iwres <- (DV-rx_pred_)/sqrt(rx_r_))),
                   lapply(seq(.l+1, length(.lstExpr)), function(i) .lstExpr[[i]]))
      .lstOut <- as.call(list(quote(`model`), as.call(.lstOut)))
      rxode2::model(.ret) <- .lstOut
      .ret
    }
    .ret <- rxode2::rxModelVars(.ret)
    .ret <- rxode2(.ret)
    .ret
  }
}
