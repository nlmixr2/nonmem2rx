.onLoad <- function(libname, pkgname) {
  .Call(`_nonmem2rx_r_parseIni`)
  if (requireNamespace("nlme", quietly=TRUE)) {
    rxode2::.s3register("nlme::getData", "nonmem2rx")
  }
}
.onAttach <- function(libname,pkgname){
  .Call(`_nonmem2rx_r_parseIni`)
}
