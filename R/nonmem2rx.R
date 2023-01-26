.nonmem2rx <- new.env(parent=emptyenv())
#' Clear the .nonmem2rx environment
#'  
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.clearNonmem2rx <- function() {
  .ls <- ls(all=TRUE, envir=.nonmem2rx)
  if (length(.ls) > 0L) rm(list=.ls,envir=.nonmem2rx)
  .nonmem2rx$ini <- NULL
  .nonmem2rx$thetaNames <- NULL
  .nonmem2rx$model <- NULL
}
#' Add theta name to .nonmem2rx info
#'
#'  
#' @param theta string representing variable name
#' @return Nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addThetaName <- function(theta) {
  assign("theta", c(.nonmem2rx$theta, theta), envir=.nonmem2rx)
}
#' Add to initialization block
#'
#' @param text Line to add to the initialization block
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addIni <- function(text) {
  assign("ini", c(.nonmem2rx$ini, text), envir=.nonmem2rx)
}
#' Add to model block
#'
#' @param text line to add to the model block
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
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
  loadNamespace("dparser")
  .clearNonmem2rx()
  if (file.exists(file)) {
    .lines <- paste(readLines(file), collapse = "\n")
  } else {
    .lines <- file
  }
  .parseRec(.lines)
  eval(parse(text=paste0("function() {\n",
                         "ini({\n",
                         paste(.nonmem2rx$ini, collapse="\n"),
                         "\n})\n",
                         "}")))
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
