#' Read in data file
#'  
#' @inheritParams nmtab
#' @export 
#' @author Philip Delff and Matthew L. Fidler
#' @examples
#' nmcov(system.file("mods/cpt/runODE032.cov", package="nonmem2rx"))
nmcov <- function (file, ...) {
  checkmate::assertFileExists(file)
  TABLE <- NULL
  NMREP <- NULL
  NAME <- NULL
  ..name <- NULL
  colnames <- readLines(file, n=2)[2]
  if (grepl(", *OMEGA\\( *1 *, *1\\)", colnames)) {
    # in this case the NAME also has commas
    lines <- readLines(file)
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
  dt1 <- dt1[NMREP==1,]
  name <- dt1$NAME
  dt1[,`:=`(NAME, NULL)]
  dt1[, `:=`(NMREP, NULL),]
  dt1 <- dt1[,..name]
  cnames <- colnames(dt1)
  dt1[, `:=`((cnames), lapply(.SD, as.numeric))]
  dt1 <- as.matrix(dt1)
  dn <- dimnames(dt1)
  dn[[1]] <- dn[[2]]
  dimnames(dt1) <- dn
  return(dt1)
}
