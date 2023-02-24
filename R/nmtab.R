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
  dt1 <- fread(file, fill = TRUE, header = TRUE, skip = 1, 
               ...)
  cnames <- colnames(dt1)
  if (length(cnames) == 0L) return(NULL)
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
  return(dt1)
}
