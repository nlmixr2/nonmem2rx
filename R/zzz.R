.onLoad <- function(libname, pkgname) {
  .Call(`_nonmem2rx_r_parseIni`)
  if (requireNamespace("nlme", quietly=TRUE)) {
    rxode2::.s3register("nlme::getData", "nonmem2rx")
  }
  if (requireNamespace("dplyr", quietly=TRUE)) {
    rxode2::.s3register("dplyr::rename", "nonmem2rx")
  }
  .rxUiGetRegister()

}
.onAttach <- function(libname,pkgname){
  .Call(`_nonmem2rx_r_parseIni`)
}
