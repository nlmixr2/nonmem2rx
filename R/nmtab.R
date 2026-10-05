#' Read nonmem table file
#'
#'
#' @param file file name to read the results from
#' @param ... other parameters passed to `data.table::fread`
#' @return data frame of the read table
#' @export
#' @author Philip Delff, Matthew L. Fidler
#' @examples
#' nmtab(system.file("mods/cpt/runODE032.csv", package="nonmem2rx"))
nmtab <- function (file, ...)
{
  checkmate::assertFileExists(file)
  TABLE <- NULL
  NMREP <- NULL
  colnames <- readLines(file, n=2, encoding="latin1")[2]
  if (grepl(", *OMEGA\\( *1 *, *1\\)", colnames)) {
    col.names <- gsub(" ", "",strsplit(colnames, " +,")[[1]])
    dt1 <- fread(file, fill = TRUE, header = TRUE, skip = 1,
                 ...)
    dt1 <- dt1[,seq_along(col.names), with=FALSE]
    setnames(dt1, col.names)
  } else {
    dt1 <- fread(file, fill = TRUE, header = TRUE, skip = 1,
                 ...)
  }
  cnames <- colnames(dt1)
  if (length(cnames) == 0L) return(NULL)
  .w <- grep("^(ETA|THETA|ERR|EPS)[(][0-9]+[)]$", cnames)
  if (length(.w) > 0L) {
    cnames[.w] <- gsub("[(]([0-9]+)[)]$", "\\1", cnames[.w])
    setnames(dt1, cnames)
  }
  dt1[grep("^TABLE", as.character(get(cnames[1])), invert = FALSE,
           perl = TRUE), `:=`(TABLE, get(cnames[1]))]
  dt1[, `:=`(NMREP, cumsum(!is.na(TABLE)) + 1)]
  dt1[, `:=`(TABLE, NULL)]
  dt1 <- dt1[grep("^ *[[:alpha:]]", as.character(get(cnames[1])),
                  invert = TRUE, perl = TRUE)]
  cols.dup <- duplicated(colnames(dt1))
  if (any(cols.dup)) {
    .minfo(paste0("Cleaned duplicated column names: ",
                  paste(colnames(dt1)[cols.dup], collapse = ",")))
    dt1 <- dt1[, unique(cnames), with = FALSE]
  }
  cnames <- colnames(dt1)
  dt1[, `:=`((cnames), lapply(.SD, as.numeric))]
  dt1 <- as.data.frame(dt1)
  dt1
}

#' Which table of a NONMEM output file holds the final estimates
#'
#' NONMEM writes one table per estimation step (`$EST` record) to the
#' `.ext`, `.phi`, `.cov`, `.cor`, `.coi` and `.grd` files, and further
#' tables for later problems.  The final estimates are in the last
#' estimation table of the first problem.
#'
#' @param file NONMEM output file
#' @return the table number (as `nmtab()`'s `NMREP`), 1 when the file has
#'   one table or its headers carry no problem number
#' @noRd
#' @author Matthew L. Fidler
.nmFinalTable <- function(file) {
  .h <- grep("^TABLE NO[.]", readLines(file, warn=FALSE, encoding="latin1"),
             value=TRUE)
  if (length(.h) <= 1L) return(1L)
  .num <- function(key) {
    .r <- regmatches(.h, regexec(paste0(key, "=([0-9]+)"), .h))
    vapply(.r, function(x) if (length(x) == 2L) as.integer(x[2]) else NA_integer_,
           integer(1))
  }
  .prob <- .num("Problem")
  if (all(is.na(.prob))) return(1L)
  .sub <- .num("Subproblem")
  .w <- which(.prob == .prob[1] & (is.na(.sub) | .sub == 0L))
  if (length(.w) == 0L) return(1L)
  max(.w)
}

#' Column names of the k-th table of a NONMEM output file
#'
#' @param file NONMEM output file
#' @param k table number
#' @return column names (with `ETA(1)` style names changed to `ETA1`, as
#'   `nmtab()` does), or `NULL` when the table is not found
#' @noRd
#' @author Matthew L. Fidler
.nmTableHeader <- function(file, k) {
  .l <- readLines(file, warn=FALSE, encoding="latin1")
  .h <- grep("^TABLE NO[.]", .l)
  if (length(.h) < k || .h[k] >= length(.l)) return(NULL)
  .n <- strsplit(trimws(.l[.h[k] + 1L]), " +")[[1]]
  gsub("^(ETA|THETA|ERR|EPS)[(]([0-9]+)[)]$", "\\1\\2", .n)
}
