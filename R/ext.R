#' Reads the NONMEM `.ext` file for final parameter information
#'
#' This uses `pmxTools` for reading the file
#'
#' @param file File where the list is located
#' @return return a list with `$theta`, `$eta` and `$eps`
#' @export
#' @author Matthew L. Fidler
#' @examples
#'
#' nmext(system.file("run001.ext", package="nonmem2rx"))
nmext <- function(file) {
  .lst <- suppressWarnings(pmxTools::read_nmext(file))
  if (length(.lst$Thetas) > 0) {
    .theta <- setNames(.lst$Thetas, paste0("theta", seq_along(.lst$Thetas)))
  } else {
    .theta <- NULL
  }
  if (length(.lst$Omega) > 0) {
    .omega <- eval(parse(text=paste0("lotri::lotri(",
                                     paste(paste0("eta",seq_along(.lst$Omega)), collapse="+"),
                                     "~ ",
                                     deparse1(unlist(.lst$Omega)),
                                     ")")))
  } else {
    .omega <- NULL
  }
  if (length(.lst$Omega) > 0) {
    .omega <- eval(parse(text=paste0("lotri::lotri(",
                                     paste(paste0("eta",seq_along(.lst$Omega)), collapse="+"),
                                     "~ ",
                                     deparse1(unlist(.lst$Omega)),
                                     ")")))
  } else {
    .omega <- NULL
  }

  if (length(.lst$Sigma) > 0) {
    .sigma <- eval(parse(text=paste0("lotri::lotri(",
                                     paste(paste0("eps",seq_along(.lst$Sigma)), collapse="+"),
                                     "~ ",
                                     deparse1(unlist(.lst$Sigma)),
                                     ")")))
  } else {
    .sigma <- NULL
  }
  list(theta=.theta,
       eta=.omega,
       eps=.sigma)
}
