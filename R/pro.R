#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.pro <- function(x) {
  .x <- x
  class(.x) <- NULL
  .ret <- NULL
  for (.cur in .x) {
    .ret <- c(.ret, strsplit(.cur, "\n")[[1]])
  }
  .ret <- gsub("^ *(.*) *$", "\\1", .ret)
  .nonmem2rx$modelDesc <- c(.nonmem2rx$modelDesc, .ret)
}
#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.aaa <- nonmem2rxRec.pro
