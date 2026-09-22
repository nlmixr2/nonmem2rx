#' Autoplot nonmem2rx object
#'
#' @param ... ignored parameters for `nonmem2rx` objects
#' @param page number of page(s) for the individual plots, by default
#'   (`FALSE`) no pages are print; You can use `TRUE` for all pages to
#'   print, or list which pages you want to print
#' @return a ggplot2 object
#' @inheritParams rxode2::plot.rxSolve
#' @inheritParams ggplot2::autoplot
#' @inheritParams ggforce::facet_wrap_paginate
#' @keywords internal
autoplot.nonmem2rx <- function(object, ...,
                               ncol=3, nrow=3, log="", xlab = "Time", ylab = "Predictions",
                               page=FALSE) {
  stopifnot(length(log) == 1)
  stopifnot(is.character(log))
  if (is.logical(page)) {
    if (page) {
      page <- NULL
    }
  } else {
    checkmate::assertIntegerish(page, lower=1, any.missing = FALSE, null.ok=TRUE)
  }
  stopifnot(log %in% c("", "x", "y", "xy", "yx"))
  .useLogX <- nchar(log) == 2 | log == "x"
  .useLogY <- nchar(log) == 2 | log == "y"
  if (is.null(object$predCompare)) {
    warning("nothing to plot", call. = FALSE)
    return(invisible())
  }
  # IPRED is drawn first so PRED points overlay IPRED points
  .types <- c(IPRED="ipredCompare", PRED="predCompare")
  if (is.logical(page) && !page) {
    .types <- c(.types, IWRES="iwresCompare")
  }
  .data <- lapply(names(.types), function(type) {
    .plotCompareData(object[[.types[type]]], type)
  })
  .hasEndpoint <- any(vapply(.data, function(d) {
    any(names(d) == "endpoint")
  }, logical(1)))
  if (.hasEndpoint) {
    .data <- lapply(.data, function(d) {
      if (!is.null(d) && !any(names(d) == "endpoint")) d$endpoint <- NA_character_
      d
    })
  }
  .data <- do.call(rbind, .data)
  .data$type <- factor(.data$type,
                       intersect(c("PRED", "IPRED", "IWRES"), unique(.data$type)))
  if (.hasEndpoint) {
    .data$endpoint[is.na(.data$endpoint)] <- "NA"
    .data$endpoint <- factor(.data$endpoint, .sortEndpoint(unique(.data$endpoint)))
  }
  if (is.logical(page) && !page) {
    if (.hasEndpoint) {
      .facet <- facet_wrap(~type + endpoint, scales="free",
                           labeller=ggplot2::label_wrap_gen(multi_line=FALSE))
    } else {
      .facet <- facet_wrap(~type, scales="free")
    }
    return(ggplot(data=.data, aes(.data$rxode2, .data$nonmem)) +
             geom_point() +
             .facet +
             rxode2::rxTheme() +
             ylab("NONMEM") +
             xlab("rxode2"))
  }
  if (.hasEndpoint) {
    # each panel is an id/endpoint combination; order by id first
    .data$panel <- paste0("id=", .data$id, "; ", .data$endpoint)
    .data <- .data[order(.data$id, as.integer(.data$endpoint), .data$type, .data$time), ]
    .data$panel <- factor(.data$panel, unique(.data$panel))
  } else {
    .data$panel <- .data$id
  }

  .npage <- ceiling(length(unique(.data$panel))/(ncol*nrow))

  .useXgxr <-
    getOption("rxode2.xgxr", TRUE) &&
    requireNamespace("xgxr", quietly = TRUE)
  .logx <- NULL
  .logy <- NULL
  if (.useLogX) {
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
  .scales <- ifelse(.hasEndpoint, "free_y", "fixed")
  if (is.null(page)) {
      .pages <- seq_len(.npage)
  } else {
    .pages <- page
    .pages <- .pages[.pages <= .npage]
  }

  .ret <- lapply(.pages,
                   function(p) {
                     .ret <- ggplot(data=.data, aes(.data$time, .data$rxode2, col=.data$type)) +
                       geom_point() +
                       ggforce::facet_wrap_paginate(~.data$panel,
                                                    ncol=ncol, nrow=nrow, page=p,
                                                    scales=.scales) +
                       geom_line(aes(.data$time, .data$nonmem)) +
                       ylab(ylab) +
                       xlab(xlab) +
                       rxode2::rxTheme() +
                       theme(legend.position="top") + .logy +
                       .logx +
                       ggtitle(paste0("Lines: NONMEM; Points: rxode2; Page ", p, " of ", .npage))
                   })
  if (length(.ret) == 1L) return(.ret[[1]])
  .ret
}

#' Standardize a comparison dataset for plotting
#'
#' @param cmp comparison dataset (`predCompare`, `ipredCompare`,
#'   `iwresCompare`), possibly with an `ENDPOINT` column
#' @param type type of comparison (`"PRED"`, `"IPRED"`, `"IWRES"`)
#' @return standardized data frame with `id`, `time`, (optionally)
#'   `endpoint`, `nonmem`, `rxode2` and `type`; `NULL` if `cmp` is
#'   `NULL`
#' @noRd
#' @author Matthew L. Fidler
.plotCompareData <- function(cmp, type) {
  if (is.null(cmp)) return(NULL)
  .n <- length(cmp)
  .ret <- data.frame(id=cmp[[1]], time=cmp[[2]],
                     nonmem=cmp[[.n - 1L]], rxode2=cmp[[.n]], type=type)
  if (any(names(cmp) == "ENDPOINT")) {
    .ret$endpoint <- as.character(cmp$ENDPOINT)
  }
  .ret
}

#' Sort endpoint labels by their numeric value when possible
#'
#' @param endpoint unique endpoint labels like `"CMT=2"`
#' @return sorted endpoint labels
#' @noRd
#' @author Matthew L. Fidler
.sortEndpoint <- function(endpoint) {
  .num <- suppressWarnings(as.numeric(sub("^[^=]*=", "", endpoint)))
  endpoint[order(.num, endpoint)]
}

#' Standardize a comparison dataset for plotting
#'
#' @param cmp comparison dataset (`predCompare`, `ipredCompare`,
#'   `iwresCompare`), possibly with an `ENDPOINT` column
#' @param type type of comparison (`"PRED"`, `"IPRED"`, `"IWRES"`)
#' @return standardized data frame with `id`, `time`, (optionally)
#'   `endpoint`, `nonmem`, `rxode2` and `type`; `NULL` if `cmp` is
#'   `NULL`
#' @noRd
#' @author Matthew L. Fidler
.plotCompareData <- function(cmp, type) {
  if (is.null(cmp)) return(NULL)
  .n <- length(cmp)
  .ret <- data.frame(id=cmp[[1]], time=cmp[[2]],
                     nonmem=cmp[[.n - 1L]], rxode2=cmp[[.n]], type=type)
  if (any(names(cmp) == "ENDPOINT")) {
    .ret$endpoint <- as.character(cmp$ENDPOINT)
  }
  .ret
}

#' Sort endpoint labels by their numeric value when possible
#'
#' @param endpoint unique endpoint labels like `"CMT=2"`
#' @return sorted endpoint labels
#' @noRd
#' @author Matthew L. Fidler
.sortEndpoint <- function(endpoint) {
  .num <- suppressWarnings(as.numeric(sub("^[^=]*=", "", endpoint)))
  endpoint[order(.num, endpoint)]
}

plot.nonmem2rx <- function(x, ..., ncol=3, nrow=3, log="",  xlab = "Time", ylab = "Predictions", page=FALSE) {
  .ret <- autoplot.nonmem2rx(object=x, ..., ncol=ncol, nrow=nrow, log=log, xlab=xlab, ylab=ylab, page=page)
  if (inherits(.ret, "ggplot")) {
        print(.ret)
  } else {
    lapply(seq_along(.ret), function(i) {
      print(.ret[[i]])
    })
  }
  invisible()
}
