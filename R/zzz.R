.dparserLoad <- function() {
  .Call(`_nonmem2rx_iniDparserPtr`,
        dparser::.dparsePtr(),
        PACKAGE = "nonmem2rx")
}
.onLoad <- function(libname, pkgname) {
  .dparserLoad()
  .Call(`_nonmem2rx_r_parseIni`)
  if (requireNamespace("nlme", quietly=TRUE)) {
    rxode2::.s3register("nlme::getData", "nonmem2rx")
  }
  rxode2::.s3register("ggplot2::autoplot", "nonmem2rx")
  rxode2::.s3register("base::plot", "nonmem2rx")
  .rxUiGetRegister()
  rxode2::.s3register("rxode2::rxUiGet", "simulationModelIwres")
}
.onAttach <- function(libname,pkgname){
  .dparserLoad()
  .Call(`_nonmem2rx_r_parseIni`)
}
