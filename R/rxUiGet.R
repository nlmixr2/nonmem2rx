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
    .ret <- suppressMessages(rxode2::model(.ui, iwres <- (DV-rx_pred_)/sqrt(rx_r_),
                                           append=sim, auto=FALSE))
    .ret <- rxode2::rxModelVars(.ret)
    .ret <- rxode2(.ret)
    .ret
  }
}
