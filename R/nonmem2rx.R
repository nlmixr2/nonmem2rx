.nonmem2rx <- new.env(parent=emptyenv())

.clearNonmem2rx <- function() {
  .ls <- ls(all=TRUE, envir=.nonmem2rx)
  if (length(.ls) > 0L) rm(list=.ls,envir=.nonmem2rx)
  .nonmem2rx$ini <- NULL
  .nonmem2rx$model <- NULL
}

.addIni <- function(text) {
  assign("ini", c(.nonmem2rx$ini, text), envir=.nonmem2rx)
}

.addModel <- function(text) {
  assign("model", c(.nonmem2rx$model, text), envir=.nonmem2rx)
}

#' Convert a NONMEM source file to a rxode control
#'
#' @param file NONMEM control file location
#'
#' @return rxode2 function
#' @eval .nonmem2rxBuildGram()
#' @export
#'
#' @useDynLib nonmem2rx, .registration=TRUE
#' @importFrom Rcpp sourceCpp
#' @examples
#' nonmem2rx(system.file("run001.mod", package="nonmem2rx"))
nonmem2rx <- function(file) {
  if (file.exists(file)) {
    .lines <- paste(readLines(file), collapse = "\n")
    .parseRec(.lines)
  }
}


### Parser build
.nonmem2rxBuildRecord <- function() {
  cat("Update Parser c for record locator\n");
  dparser::mkdparse(devtools::package_file("inst/records.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxRecords")
  file.rename(devtools::package_file("src/records.g.d_parser.c"),
              devtools::package_file("src/records.g.d_parser.h"))
}

.nonmem2rxBuildOmega <- function() {
  cat("Update Parser c for omega block\n");
  dparser::mkdparse(devtools::package_file("inst/omega.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxOmega")
  file.rename(devtools::package_file("src/omega.g.d_parser.c"),
              devtools::package_file("src/omega.g.d_parser.h"))
}



.nonmem2rxBuildTheta <- function() {
  cat("Update Parser c for theta block\n");
  dparser::mkdparse(devtools::package_file("inst/theta.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxTheta")
  file.rename(devtools::package_file("src/theta.g.d_parser.c"),
              devtools::package_file("src/theta.g.d_parser.h"))
}

.nonmem2rxBuildGram <- function() {
  .nonmem2rxBuildRecord()
  .nonmem2rxBuildTheta()
  .nonmem2rxBuildOmega()
  invisible("")
}
