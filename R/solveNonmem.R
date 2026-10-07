#' Does the installed rxode2 support `rxSolve(nonmem = TRUE)`?
#'
#' With `nonmem = TRUE`, statements that do not depend on a state (NONMEM's
#' `$PK`) read `time` as the time of the data record that ends the interval
#' being integrated, the way NONMEM calls `$PK` at its records
#' (nlmixr2/rxode2#1429).  The option comes after `...` in `rxSolve()`, so
#' older rxode2 versions reject it as an unused argument.
#'
#' @return logical
#' @noRd
#' @author Matthew L. Fidler
.nonmem2rxHasNonmemSolve <- function() {
  any(names(formals(rxode2::rxSolve)) == "nonmem")
}

#' Should this model be solved with `rxSolve(nonmem = TRUE)`?
#'
#' rxode2 treats a `delay()` assigned to a variable outside of `d/dt()` as
#' a statement that does not depend on a state, so with `nonmem = TRUE` it
#' is evaluated at the record time instead of the integration time.  The
#' delay differential equation translations (`AD_x_y`) are written that way,
#' so they keep rxode2's continuous time.
#'
#' @param model rxode2 model or ui
#' @return logical
#' @noRd
#' @author Matthew L. Fidler
.nonmem2rxUseNonmemSolve <- function(model) {
  if (!.nonmem2rxHasNonmemSolve()) return(FALSE)
  .code <- try(rxode2::rxNorm(model), silent=TRUE)
  inherits(.code, "try-error") || !any(grepl("\\bdelay\\(", .code))
}

#' Solve the way NONMEM evaluates the model
#'
#' When rxode2 supports it, this solves with `nonmem = TRUE` and
#' `addlKeepsCov = FALSE`, which together with `covsInterpolation = "nocb"`
#' match NONMEM for `TIME` in `$PK`, `MTIME` change points and covariates
#' changing between `ADDL` doses.  Otherwise it keeps `addlKeepsCov = TRUE`.
#'
#' @param model rxode2 model to solve
#' @param ... other arguments passed to `rxode2::rxSolve()`
#' @return the solved object
#' @noRd
#' @author Matthew L. Fidler
.nonmem2rxSolve <- function(model, ...) {
  if (.nonmem2rxUseNonmemSolve(model)) {
    rxode2::rxSolve(model, ..., nonmem = TRUE, addlKeepsCov = FALSE)
  } else {
    rxode2::rxSolve(model, ..., addlKeepsCov = TRUE)
  }
}
