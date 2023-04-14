#' This function gets relevant ETAs for the validation
#'
#' @param etaData nonmem eta data (derived from `.readInDataFromNonmem()`)
#' @param inputData nonmem input data (derived from `.readInPredFromTables()`)
#' @param model rxode2 model
#' @return eta data
#' @details
#'
#' NONMEM uses all data even if it does not contain any observations
#' (doses only).  `rxode2` and `nlmixr2` drop data without any observations.
#'
#' This routine tries to figure out the subjects who have data
#' remaining and keeps only those ETAs
#'
#' @noRd
#' @author Matthew L. Fidler
.getValidationEtas <- function(etaData, inputData, model) {
  if (is.null(inputData)) return(NULL)
  .eid <- unique(etaData$ID)
  .m <- rxode2::etTrans(inputData, model)
  .id <- as.numeric(levels(.m$ID))
  .ret <- etaData
  .d <- setdiff(.eid, .id)
  if (length(.d) > 0) {
    .minfo(paste0("observation only ETAs are ignored: ", paste(.d, collapse=", ")))
    return(.ret[.ret$ID %in% .id,])
  }
  return(etaData)
}

#' Fix NONMEM ties
#'
#' @param inputData  nonmem input dataset
#' @param delta shift for times
#' @return input dataset offset for tied times
#' @noRd
#' @author Matthew L. Fidler
.fixNonmemTies <- function(inputData, delta=1e-4) {
  if (is.null(inputData)) return(NULL)
  .wid <- which(tolower(names(inputData)) == "id")
  .wtime <- which(tolower(names(inputData)) == "time")
  if (length(.wid) != 1L) return(NULL)
  if (length(.wtime) != 1L) return(NULL)
  .id <- as.integer(inputData[,.wid])
  .time <- as.double(inputData[,.wtime])
  .new <- .Call(`_nonmem2rx_fixNonmemTies`, .id, .time, delta)
  .inputData <- inputData
  .inputData[,.wid] <- .id
  .inputData[,.wtime] <- .new
  .inputData
}
#' Get the nonmem observation data indexes
#'
#' @param inputData nonmem input data
#' @return nonmem observation data
#' @noRd
#' @author Matthew L. Fidler
.nonmemObsIndex <- function(inputData) {
  .wevid <- which(tolower(names(inputData)) == "evid")
  if (length(.wevid) == 1L) {
    .evid <- inputData[,.wevid]
    return(which(.evid == 0 | .evid == 2))
  }
  .wmdv <- which(tolower(names(inputData)) == "mdv")
  if (length(.wmdv) == 1L) {
    .mdv <- inputData[,.wmdv]
    return(which(.mdv == 0))
  }
  .wdv <- which(tolower(names(inputData)) == "dv")
  if (length(.wdv) == 1L) {
    .dv <- inputData[,.wdv]
    return(which(!is.na(.dv)))
  }
  seq_along(inputData[,1])
}
