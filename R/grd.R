#' Reads the NONMEM `.grd` file for final parameter gradient
#'
#'
#' @param file File where the list is located
#' @return return a list with `$rawGrad`
#' @export
#' @author Matthew L. Fidler
#' @examples
#'
#' nmgrd(system.file("mods/cpt/runODE032.grd", package="nonmem2rx"))
#'
nmgrd <- function(file) {
  checkmate::assertFile(file)
  .lst <- nmtab(file)
  if (is.null(.lst)) {
    return(list(rawGrad=NULL))
  }
  .lst <- .lst[.lst$NMREP == 1 & .lst$ITERATION == max(.lst$ITERATION),]
  .lst$NMREP <- NULL
  return(rwaGrad=unlist(.lst))
}
