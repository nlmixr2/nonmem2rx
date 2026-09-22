#' Columns of the input data that hold a $INPUT data item (and its synonym)
#'
#' `$INPUT` allows `A=B` or `B=A`, and either label can be used afterwards
#' (for example in `$DATA TRANSLATE=(...)` or `RECORDS=label`).  This returns
#' every column name in the pair that contains `label`.
#'
#' @param data data.frame with the $INPUT names (and synonyms) applied
#' @param label label to look up (case insensitive)
#' @return character vector of column names in `data`
#' @noRd
#' @author Matthew L. Fidler
.dataItemCols <- function(data, label) {
  .inp <- .nonmem2rx$input
  .lab <- toupper(label)
  .w <- which(toupper(names(.inp)) == .lab | toupper(.inp) == .lab)
  .cols <- unique(c(names(.inp)[.w], unname(.inp[.w]), label))
  .cols <- .cols[.cols != "DROP"]
  names(data)[toupper(names(data)) %in% toupper(.cols)]
}

#' Number contiguous runs of equal values (missing values compare equal)
#'
#' @param x vector (e.g. the ID data item)
#' @return integer run number for each element
#' @noRd
#' @author Matthew L. Fidler
.dataRuns <- function(x) {
  .x <- as.character(x)
  .x[is.na(.x)] <- "\001NA"
  cumsum(c(TRUE, .x[-1] != .x[-length(.x)]))[seq_along(.x)]
}

#' Convert NONMEM clock times (`hh:mm` or `hh:mm:ss`) to hours
#'
#' @param x vector of times; values without a `:` are taken as hours
#' @return numeric hours
#' @noRd
#' @author Matthew L. Fidler
.dataClockHours <- function(x) {
  .x <- trimws(as.character(x))
  .ret <- suppressWarnings(as.numeric(.x))
  .w <- which(grepl(":", .x, fixed=TRUE))
  if (length(.w) > 0L) {
    .ret[.w] <- vapply(strsplit(.x[.w], ":", fixed=TRUE),
                       function(v) {
                         v <- as.numeric(v)
                         sum(v / c(1, 60, 3600)[seq_along(v)])
                       }, numeric(1), USE.NAMES=FALSE)
  }
  .ret
}

#' Convert NONMEM date data items to a day number
#'
#' The field order depends on the reserved label: `DATE` (month day year),
#' `DAT1` (day month year), `DAT2` (year month day), `DAT3` (year day
#' month).  One field is a day; two fields are month and day; one or two
#' digit years are placed in a century by `LAST20`.  Month/day dates without
#' a year use the year of the individual's last full date (a leap year if
#' there is none) and move to the next year when the date goes backwards
#' within an individual (e.g. 12/31 followed by 1/1).
#'
#' @param x vector of dates
#' @param type reserved date label (`DATE`, `DAT1`, `DAT2`, `DAT3`)
#' @param last20 `$DATA LAST20` value
#' @param id individual (contiguous records)
#' @return numeric days
#' @noRd
#' @author Matthew L. Fidler
.dataDateDays <- function(x, type, last20=50L, id=rep(1L, length(x))) {
  .order <- switch(toupper(type),
                   DATE=c("m", "d", "y"),
                   DAT1=c("d", "m", "y"),
                   DAT2=c("y", "m", "d"),
                   DAT3=c("y", "d", "m"))
  .days <- function(y, m, d) {
    as.numeric(as.Date(sprintf("%04d-%02d-%02d", as.integer(y),
                               as.integer(m), as.integer(d))))
  }
  .fields <- lapply(strsplit(trimws(as.character(x)), "[^0-9]+"),
                    function(v) suppressWarnings(as.numeric(v[v != ""])))
  .ret <- rep(NA_real_, length(x))
  .year <- 2000
  .last <- NA_real_
  for (.i in seq_along(.fields)) {
    v <- .fields[[.i]]
    if (.i == 1L || id[.i] != id[.i - 1L]) {
      .year <- 2000
      .last <- NA_real_
    }
    if (length(v) == 0L || length(v) > 3L || anyNA(v)) next
    if (length(v) == 1L) {
      .ret[.i] <- v
    } else if (length(v) == 2L) {
      names(v) <- .order[.order != "y"]
      .d <- .days(.year, v["m"], v["d"])
      if (!is.na(.last) && !is.na(.d) && .d < .last) {
        .year <- .year + 1
        .d <- .days(.year, v["m"], v["d"])
      }
      .ret[.i] <- .last <- .d
    } else {
      names(v) <- .order
      if (v["y"] < 100) {
        v["y"] <- v["y"] + ifelse(v["y"] > last20, 1900, 2000)
      }
      # later month/day dates of this individual continue from this year
      .year <- v[["y"]]
      .ret[.i] <- .last <- .days(v["y"], v["m"], v["d"])
    }
  }
  .ret
}

#' Fill missing values forward within each individual
#'
#' @param x numeric vector
#' @param id individual (contiguous records)
#' @return `x` with `NA` replaced by the prior value in the same individual
#' @noRd
#' @author Matthew L. Fidler
.dataFillForward <- function(x, id) {
  for (.i in seq_along(x)[-1]) {
    if (is.na(x[.i]) && id[.i] == id[.i - 1L]) x[.i] <- x[.i - 1L]
  }
  x
}

#' Apply NM-TRAN day-time translation and `$DATA TRANSLATE`
#'
#' When a TIME value contains `:` or a date data item (`DATE`, `DAT1`,
#' `DAT2`, `DAT3`) is in `$INPUT`, TIME is converted to the time elapsed since
#' the first record of each individual; II values with `:` are converted to
#' hours.  Afterwards any `TRANSLATE=(TIME/F/D, II/F/D)` divides the item by
#' `F` and rounds to `D` digits.
#'
#' @param data data.frame after $INPUT names, synonyms and IGNORE/ACCEPT
#' @return translated data.frame
#' @noRd
#' @author Matthew L. Fidler
.dataTimeTranslate <- function(data) {
  .inp <- .nonmem2rx$input
  .setCols <- function(data, cols, value) {
    for (.c in cols) data[[.c]] <- value
    data
  }
  .timeCols <- .dataItemCols(data, "TIME")
  .dateType <- intersect(c("DATE", "DAT1", "DAT2", "DAT3"),
                         toupper(c(names(.inp), .inp)))
  if (length(.timeCols) > 0L) {
    .time <- data[[.timeCols[1]]]
    .hasClock <- any(grepl(":", as.character(.time), fixed=TRUE))
    if (.hasClock || length(.dateType) > 0L) {
      .minfo("translating clock times/dates to relative times (NM-TRAN day-time translation)")
      .idCols <- .dataItemCols(data, "ID")
      if (length(.idCols) > 0L) {
        .id <- .dataRuns(data[[.idCols[1]]])
      } else {
        .id <- rep(1L, nrow(data))
      }
      .hours <- .dataFillForward(.dataClockHours(.time), .id)
      if (length(.dateType) > 0L) {
        .dateCols <- .dataItemCols(data, .dateType[1])
        if (length(.dateCols) > 0L) {
          .days <- .dataDateDays(data[[.dateCols[1]]], .dateType[1],
                                 .nonmem2rx$dataLast20, .id)
          .hours <- .hours + 24 * .dataFillForward(.days, .id)
        }
      }
      .first <- .hours[!duplicated(.id)][.id]
      data <- .setCols(data, .timeCols, .hours - .first)
    }
  }
  .iiCols <- .dataItemCols(data, "II")
  if (length(.iiCols) > 0L &&
        any(grepl(":", as.character(data[[.iiCols[1]]]), fixed=TRUE))) {
    .minfo("translating II clock times to hours")
    data <- .setCols(data, .iiCols, .dataClockHours(data[[.iiCols[1]]]))
  }
  for (.lab in names(.nonmem2rx$dataTranslate)) {
    .t <- .nonmem2rx$dataTranslate[[.lab]]
    .cols <- .dataItemCols(data, .lab)
    if (length(.cols) == 0L) next
    .minfo(sprintf("$DATA TRANSLATE: %s/%s (%d digits)", .lab, format(.t$factor),
                   .t$digits))
    .v <- suppressWarnings(as.numeric(as.character(data[[.cols[1]]])))
    data <- .setCols(data, .cols, round(.v / .t$factor, .t$digits))
  }
  data
}

#' Apply `$DATA RECORDS=` to the (comment-free) input data
#'
#' `RECORDS=n` keeps the first `n` records; `RECORDS=label` keeps the leading
#' contiguous records that share the first record's value of `label`.  Both
#' are applied before IGNORE/ACCEPT, as NM-TRAN does.
#'
#' @param data data.frame with $INPUT names and synonyms applied
#' @return data.frame limited to the requested records
#' @noRd
#' @author Matthew L. Fidler
.dataApplyRecords <- function(data) {
  if (!is.na(.nonmem2rx$dataRecords)) {
    .minfo(sprintf("using the first %d records", .nonmem2rx$dataRecords))
    return(data[seq_len(min(.nonmem2rx$dataRecords, nrow(data))), , drop=FALSE])
  }
  .lab <- .nonmem2rx$dataRecordsLabel
  if (is.null(.lab) || nrow(data) == 0L) return(data)
  if (toupper(.lab) %in% c("IR", "INDREC", "INDIVIDUALRECORD")) .lab <- "ID"
  .cols <- .dataItemCols(data, .lab)
  if (length(.cols) == 0L) return(data)
  .n <- sum(.dataRuns(data[[.cols[1]]]) == 1L)
  .minfo(sprintf("RECORDS=%s: using the first %d records", .lab, .n))
  data[seq_len(.n), , drop=FALSE]
}
