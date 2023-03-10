#' Reads the NONMEM `.ext` file for final parameter information
#'
#'
#' @param file File where the list is located
#' @return return a list with `$theta`, `$eta` and `$eps`
#' @export
#' @author Matthew L. Fidler
#' @examples
#'
#' nmext(system.file("run001.ext", package="nonmem2rx"))
nmext <- function(file) {
  checkmate::assertFile(file)
  .lst <- nmtab(file)
  if (is.null(.lst)) {
    return(list(theta=NULL,
                omega=NULL,
                sigma=NULL,
                objf=NULL))

  }
  .lst <- .lst[.lst$NMREP == 1 & .lst$ITERATION == -1e+09,]
  if (length(.lst$OBJ) == 0L) {
    return(list(theta=NULL,
                omega=NULL,
                sigma=NULL,
                objf=NULL))
  }
  .w <- which(regexpr("THETA[1-9][0-9]*",names(.lst)) != -1)
  if (length(.w) > 0) {
    .theta <- unlist(.lst[,.w])
    names(.theta) <- gsub("^THETA", "theta", names(.theta))
  } else {
    .theta <- NULL
  }
  .w <- which(regexpr("^OMEGA",names(.lst)) != -1)
  if (length(.w) > 0) {
    .omega <-  unlist(.lst[,.w])
    names(.omega) <- NULL
    .omega <- eval(parse(text=paste0("lotri::lotri(",
                           paste(paste0("eta",seq_len(sqrt(1 + length(.omega) * 8)/2 - 1/2)), collapse="+"),
                           "~ ",
                           deparse1(.omega),
                           ")")))
  } else {
    .omega <- NULL
  }
  .w <- which(regexpr("^SIGMA",names(.lst)) != -1)
  if (length(.w) > 0) {
    .sigma <-  unlist(.lst[,.w])
    names(.sigma) <- NULL
    .sigma <- eval(parse(text=paste0("lotri::lotri(",
                                     paste(paste0("eps",seq_len(sqrt(1 + length(.sigma) * 8)/2 - 1/2)), collapse="+"),
                                     "~ ",
                                     deparse1(.sigma),
                                     ")")))
  } else {
    .sigma <- NULL
  }
  list(theta=.theta,
       omega=.omega,
       sigma=.sigma,
       objf=.lst$OBJ)
}
