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
#' @export 
#' @author Matthew L. Fidler
#' @examples 
.getValidationEtas <- function(etaData, inputData, model) {
  .eid <- unique(etaData$ID)
  .m <- rxode2::etTrans(inputData, model)
  .id <- as.numeric(levels(.m$ID))
  .ret <- etaData
  .d <- setdiff(.eid, .id)
  if (length(.d) > 0) {
    .id.minfo(paste0("observation only ETAs are ignored: ", paste(.d, collapse=", ")))
    return(.ret[.ret$ID %in% .id,])
  }
  return(etaData)
}
