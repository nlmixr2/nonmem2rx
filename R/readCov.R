#' Read in data file
#'
#' @inheritParams nmtab
#'
#' @return A matrix with covariance step from NONMEM
#'
#' @export
#'
#' @author Philip Delff and Matthew L. Fidler
#'
#' @examples
#'
#' nmcov(system.file("mods/cpt/runODE032.cov", package="nonmem2rx"))
nmcov <- function (file, ...) {
  checkmate::assertFileExists(file)
  TABLE <- NULL
  NMREP <- NULL
  NAME <- NULL
  colnames <- readLines(file, n=2, encoding = "latin1")[2]
  if (grepl(", *OMEGA\\( *1 *, *1\\)", colnames)) {
    # in this case the NAME also has commas
    lines <- readLines(file, encoding="latin1")
    lines <- gsub("(OMEGA|SIGMA)[(]([0-9]+),([0-9]+)[)]", "\\1\\2AAAAAAAAA\\3", lines)
    file2 <- tempfile()
    writeLines(lines, file2)
    dt1 <- fread(file2, fill = TRUE, header = TRUE, skip = 1, sep=",",
                 ...)
    unlink(file2)
    dt1$NAME <- gsub("[A]([0-9]+)AAAAAAAAA([0-9]+)", "A(\\1,\\2)", dt1$NAME)
    setnames(dt1, gsub("[A]([0-9]+)AAAAAAAAA([0-9]+)", "A(\\1,\\2)", names(dt1)))
  } else {
    dt1 <- fread(file, fill = TRUE, header = TRUE, skip = 1,
                 ...)
  }
  cnames <- colnames(dt1)
  dt1[grep("^TABLE", as.character(get(cnames[1])), invert = FALSE,
           perl = TRUE), `:=`(TABLE, get(cnames[1]))]
  dt1[, `:=`(NMREP, cumsum(!is.na(TABLE)) + 1)]
  dt1[, `:=`(TABLE, NULL)]
  .final <- .nmFinalTable(file)
  dt1 <- dt1[NMREP==.final,]
  if (.final > 1L) {
    # a later table starts with its own "TABLE NO." and NAME header rows,
    # which also made fread() read the numbers as text
    dt1 <- dt1[!(NAME %in% c("NAME", "") | grepl("^TABLE", NAME)), ]
    for (.c in setdiff(names(dt1), c("NAME", "NMREP", "TABLE"))) {
      set(dt1, j=.c, value=suppressWarnings(as.numeric(dt1[[.c]])))
    }
  }
  name <- dt1$NAME
  dt1[,`:=`(NAME, NULL)]
  dt1[, `:=`(NMREP, NULL),]
  dt1 <- dt1[,name, with=FALSE]
  cnames <- colnames(dt1)
  dt1[, `:=`((cnames), lapply(.SD, as.numeric))]
  dt1 <- as.matrix(dt1)
  dn <- dimnames(dt1)
  dn[[1]] <- dn[[2]]
  dimnames(dt1) <- dn
  dt1
}
