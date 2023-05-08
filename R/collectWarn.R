# .collectWarn --------------------------------------------------------
#' Collect warnings and just warn once.
#'
#' @param expr R expression
#' @return a list with the value of
#'     the expression and a list of warning messages
#' @author Matthew L. Fidler
#' @noRd
.collectWarn <- function(expr, lst = FALSE) {
  if (getOption("nlmixr2.collectWarnings", TRUE)) {
    ws <- character(0)
    this.env <- environment()
    ret <-
      suppressWarnings(withCallingHandlers(
        expr,
        warning = function(w) {
          assign("ws", unique(c(w$message, ws)), this.env)
        }
      ))
    list(ret, ws)
  } else {
    expr
  }
}
