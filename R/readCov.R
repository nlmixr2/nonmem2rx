#' Read in data file
#'  
#' @inheritParams nmtab
#' @export 
#' @author Philip Delff and Matthew L. Fidler
#' @examples
#' nmcov(system.file("mods/cpt/runODE032.cov", package="nonmem2rx"))
nmcov <- function (file, ...) {
  checkmate::assertFileExists(file)
  TABLE <- NULL
  NMREP <- NULL
  NAME <- NULL
  dt1 <- data.table::fread(file, fill = TRUE, header = TRUE, skip = 1, ...)
  cnames <- colnames(dt1)
  dt1[grep("^TABLE", as.character(get(cnames[1])), invert = FALSE, 
           perl = TRUE), `:=`(TABLE, get(cnames[1]))]
  dt1[, `:=`(NMREP, cumsum(!is.na(TABLE)) + 1)]
  dt1[, `:=`(TABLE, NULL)]
  dt1[,`:=`(NAME, NULL)]
  dt1 <- dt1[NMREP==1,]
  dt1[, `:=`(NMREP, NULL),]
  cnames <- colnames(dt1)
  dt1[, `:=`((cnames), lapply(.SD, as.numeric))]
  dt1 <- as.matrix(dt1)
  dn <- dimnames(dt1)
  dn[[1]] <- dn[[2]]
  dimnames(dt1) <- dn
  return(dt1)
}
