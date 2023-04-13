#' Autoplot nonmem2rx object
#' 
#' @param ... ignored parameters for `nonmem2rx` objects
#' @inheritParams rxode2::plot.rxSolve
#' @inheritParams ggplot2::autoplot
#' @inheritParams ggforce::facet_wrap_paginate
#' @export
autoplot.nonmem2rx <- function(object, ...,
                               ncol=3, nrow=3, log="") {
  stopifnot(length(log) == 1)
  stopifnot(is.character(log))
  stopifnot(log %in% c("", "x", "y", "xy", "yx"))
  .useLogX <- nchar(log) == 2 | log == "x"
  .useLogY <- nchar(log) == 2 | log == "y"

  .data <- object$ipredCompare
  names(.data) <- c("id", "time", "nonmem", "rxode2")
  .data$type <- "IPRED"
  .data2 <- object$predCompare
  names(.data2) <- c("id", "time", "nonmem", "rxode2")
  .data2$type <- "PRED"
  .data <- rbind(.data, .data2)
  .data$type <- factor(.data$type, c("PRED", "IPRED"))
  .ret <- list(
    ggplot(data=.data, aes(.data$rxode2, .data$nonmem)) +
      geom_point() +
      facet_wrap(~type) +
      rxode2::rxTheme() +
      ylab("NONMEM") +
      xlab("rxode2")
  )
  .ids <- unique(.data$id)
  .npage <- ceiling(length(.ids)/(ncol*nrow))

  .useXgxr <-
    getOption("rxode2.xgxr", TRUE) &&
    requireNamespace("xgxr", quietly = TRUE)
  .logx <- NULL
  .logy <- NULL
  if (.useLogX) {
    stopifnot(".dat requires 'time' column"="time" %in% names(.dat))
    .dat <- .data[.data$time > 0, ]
    if (.useXgxr) {
      .logx <- xgxr::xgx_scale_x_log10()
    } else {
      .logx <- ggplot2::scale_x_log10()
    }
  }
  if (.useLogY) {
    if (.useXgxr) {
      .logy <- xgxr::xgx_scale_y_log10()
    } else {
      .logy <- ggplot2::scale_y_log10()
    }
  }


  .ret <- c(.ret,
            lapply(seq_len(.npage),
                   function(p) {
                     .ret <- ggplot(data=.data, aes(.data$time, .data$rxode2, col=.data$type)) +
                       geom_point() +
                       ggforce::facet_wrap_paginate(~.data$id,
                                                    ncol=ncol, nrow=nrow, page=p) +
                       geom_line(aes(.data$time, .data$nonmem)) +
                       ylab("Predictions") +
                       xlab("Time") +
                       rxode2::rxTheme() +
                       theme(legend.position="top") + .logy +
                       .logx
                   }))
  .ret
}

#' @export
plot.nonmem2rx <- function(x, ..., ncol=3, nrow=3, log="") {
  .ret <- autoplot.nonmem2rx(object=x, ..., ncol=ncol, nrow=nrow, log=log)
  lapply(seq_along(.ret), function(x) {
    print(x)
  })
  invisible()
}
