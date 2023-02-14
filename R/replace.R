#' Apply the $abbrev replace rules to known abbreaviated code
#'  
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.replaceAbbrev <- function() {
  for (.r in c("pk", "pre", "des", "err")) {
    if (exists(.r, envir=.recordEnv)) {
      assign(.r, .replaceAbbrevCode(get(.r, envir=.recordEnv)),
             envir=.recordEnv)
    }
  }
}

#' Replace an abbreviated code block  
#'  
#' @param code Code to replace
#' @return replaced abbreviated code
#' @noRd
#' @author Matthew L. Fidler
.replaceAbbrevCode <- function(code) {
  if (length(.nonmem2rx$replace) == 0) return(code)
  vapply(strsplit(code, "\n"),
         function(codeItem) {
           .ret <- codeItem
           for (.item in .nonmem2rx$replace) {
             .ret <- .repItem(.item, .ret)
           }
           paste(.ret, collapse = "\n")
         }, character(0), USE.NAMES=FALSE)
}
#' Create a string for a regular expression where case is ignored
#'
#' @param item chracter name
#' @return regular expression 
#' @noRd
#' @author Matthew L. Fidler
.regexpIgnoreCase <- function(item) {
  paste(vapply(seq_len(nchar(item)),
               function(i) {
                 .u <- toupper(substr(item, i, i))
                 .l <- tolower(substr(item, i, i))
                 if (.u == .l) {
                   return(paste0("[",.u, "]"))
                 }
                 paste0("[",
                        toupper(substr(item, i, i)),
                        tolower(substr(item, i, i)),
                        "]")
               }, character(1), USE.NAMES=FALSE),
        collapse="")
}
#' Replace an item according to the replacement rules
#'  
#' @param item replacement item
#' @param lines lines for replacement
#' @return replaced line
#' @export 
#' @author Matthew L. Fidler
#' @noRd
.repItem <- function(item, lines) {
  if (inherits(item, "rep1")) {
    return(.rep1(item, lines))
  } else if (inherits(item, "rep2")){
    return(.rep2(item, lines))
  } else if (inherits(item, "repDI")) {
    return(.repDI(item, lines))
  } else if (inherits(item, "repDVI")) {
    return(.repDVI(item, lines))
  }
  stop("unhandled replacement item")
}
#' Replace rep1 type of expression
#'
#'  
#' @param rep1 rep1 replacement from nonmem parsing
#' @param lines  lines to replace
#' @return replaced lines
#' @noRd
#' @author Matthew L. Fidler
.rep1 <- function(rep1, lines) {
  .reg <- paste0("\\b", .regexpIgnoreCase(rep1[[1]]), " *[(] *",
                 .regexpIgnoreCase(rep1[[2]])," *[)] *")
  .with <- paste0(toupper(ret1[[1]]), "(", rep1[[3]], ")")
  gsub(.reg, .with, lines, perl=TRUE)
}
#' Handle rep2 lines
#'  
#' @param rep2 Replace 2 lines
#' @param lines lines to replace
#' @return replaced lines
#' @noRd
#' @author Matthew L. Fidler
.rep2 <- function(rep2, lines) {
  .reg <- paste0("\\b", .regexpIgnoreCase(rep2[[1]]), "\\b")
  gsub(.reg, rep2[[2]], lines)
}
#' Handle data item replacement 
#'
#' @param repDI data item replacement
#' @param lines lines to replace
#' @return lines (possibly expanded)
#' @noRd
#' @author Matthew L. Fidler
.repDI <- function(repDI, lines) {
  .reg <- paste0("\\b", .regexpIgnoreCase(repDI[[1]]), " *[(] *",
                 .regexpIgnoreCase(repDI[[2]])," *[)] *")
  .w <- which(regexpr(.reg, lines) != -1)
  if (length(.w) == 0) return(lines)
  .elt <- .repDI[[3]]
  .prefix <- paste0("IF (", repDI[[2]], " .EQ. ", seq_along(.elt), ") ")
  .w2 <- which(.elt == 0)
  if (length(.w2) > 0) {
    .prefix <- .prefix[-.w2]
    .elt <- .elt[-.w2]
  }
  strsplit(paste(vapply(seq_len(lines), function(.i) {
    .line <- lines[.i]
    if (!(i %in% .w)) return(.line)
    paste(vapply(seq_along(.elt), function(.j) {
      paste0(.prefix[.j],
             gsub(.reg, paste0(toupper(repDI[[1]]), "(", .elt[.j], ")"),
                  .line))
    }, character(1), USE.NAMES=FALSE), collapse = "\n")
  }, character(1), USE.NAMES=FALSE), collapse = "\n"), "\n")[[1]]
}
#' Replace data value item
#'
#'  
#' @param repDVI data value replacement item
#' @param lines input lines
#' @return ouput lines (replaced)
#' @noRd
#' @author Matthew L. Fidler
.repDVI <- function(repDVI, lines) {
  .reg0 <- paste0(.regexpIgnoreCase(repDVI[[1]]), " *[(] *",
                  .regexpIgnoreCase(repDVI[[2]])," *[)] *")
  .reg <- paste0("^ *",
                 .regexpIgnoreCase(repDVI[[3]]),
                 " *=.*", .reg0)
  .w <- which(regexpr(.reg, lines) != -1)
  if (length(.w) == 0) return(lines)
  .elt <- .repDI[[3]]
  .prefix <- paste0("IF (", repDI[[2]], " .EQ. ", seq_along(.elt), ") ")
  .w2 <- which(.elt == 0)
  if (length(.w2) > 0) {
    .prefix <- .prefix[-.w2]
    .elt <- .elt[-.w2]
  }
  strsplit(paste(vapply(seq_len(lines), function(.i) {
    .line <- lines[.i]
    if (!(i %in% .w)) return(.line)
    paste(vapply(seq_along(.elt), function(.j) {
      paste0(.prefix[.j],
             gsub(.reg0, paste0(toupper(repDI[[1]]), "(", .elt[.j], ")"),
                  .line))
    }, character(1), USE.NAMES=FALSE), collapse = "\n")
  }, character(1), USE.NAMES=FALSE), collapse = "\n"), "\n")[[1]]


}
