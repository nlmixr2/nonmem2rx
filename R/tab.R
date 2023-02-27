#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.tab <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_tab`, .cur)
  }
}
.pushTableInfo <- function(file, hasPred, fullData,hasIpred, hasEta, fortranFormat) {
  .dig <- suppressWarnings(as.integer(sub("^[^.]+[.]([1-9][0-9]*)$", "\\1", fortranFormat)))
  if (is.na(.dig)) .dig <- 4L
  .nonmem2rx$tables <- c(.nonmem2rx$tables,
                         list(list(file=file, hasPred=hasPred, fullData=fullData, hasIpred=hasIpred, hasEta=hasEta,
                                   digits=.dig)))
}
