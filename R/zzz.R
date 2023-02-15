.onLoad <- function(libname, pkgname) {
  .Call(`_nonmem2rx_r_parseIni`)
}
.onAttach <- function(libname,pkgname){
  .Call(`_nonmem2rx_r_parseIni`)
}
