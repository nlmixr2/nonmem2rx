#' @export
print.nonmem2rx <- function(x, ...) {
  .tmp <- x
  .cls <- class(.tmp)
  .cls <- .cls[which(.cls != "nonmem2rx")]
  class(.tmp) <- .cls
  print(.tmp)
  .tmp <- rxode2::rxUiDecompress(.tmp)
  if (length(.tmp$notes) > 0) {
    cat(cli::cli_format_method({
      cli::cli_h2(paste0("nonmem2rx translation notes (", crayon::bold$blue("$notes"),"):"))
    }), "\n")
    lapply(.tmp$notes, function(msg) {
      cat("  ", cli::cli_format_method({
        cli::cli_li(msg)
      }), "\n")
    })
  }
  cat(cli::cli_format_method({
    cli::cli_h2("nonmem2rx extra properties:")
  }), "\n")
  if (is.null(x$predDf)) {
    cat(paste0("\n", crayon::bold("Sigma"), " (", crayon::bold$blue("$sigma"),
               "):"), "\n")
    print(x$sigma)
    cat("\n")
  }
  .b <- NULL
  for (item in c("nonmemData", "etaData", "thetaMat", "dfSub", "dfObs")) {
    if (exists(item, envir=.tmp)) {
      .b <- c(.b, crayon::bold$blue(paste0("$", item)))
    }
  }
  cat(paste0("other properties include: ", paste(.b, collapse=", "), "\n"))
  .b <- NULL
  for (item in c("predData", "ipredData")) {
    if (exists(item, envir=.tmp)) {
      .b <- c(.b, crayon::bold$blue(paste0("$", item)))
    }
  }
  cat(paste0("captured NONMEM table outputs: ", paste(.b, collapse=", "), "\n"))
  .b <- NULL
  for (item in c("iwresCompare", "predCompare", "ipredCompare")) {
    .b <- c(.b, crayon::bold$blue(paste0("$", item)))
  }
  cat(paste0("NONMEM/rxode2 comparison data: ", paste(.b, collapse=", "), "\n"))
  .b <- NULL
  for (item in c("predAtol", "predRtol", "ipredAtol", "ipredRtol", "iwresAtol", "iwresRtol")) {
    .b <- c(.b, crayon::bold$blue(paste0("$", item)))
  }
  cat(paste0("NONMEM/rxode2 composite comparison: ", paste(.b, collapse=", "), "\n"))
  invisible(x)
}
