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
  .code <- strsplit(code, "\n")
  paste(vapply(seq_along(.code),
         function(.ci) {
           .ret <- .code[[.ci]]
           for (.item in .nonmem2rx$replace) {
             .ret <- .repItem(.item, .ret)
           }
           paste(.ret, collapse = "\n")
         }, character(1), USE.NAMES=FALSE),
        collapse="\n")
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
  .reg <- paste0("(\\b|^)", .regexpIgnoreCase(rep1[[1]]), " *[(] *",
                 .regexpIgnoreCase(rep1[[2]])," *[)] *")
  .with <- paste0(toupper(rep1[[1]]), "(", rep1[[3]], ")")
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
  .datReg <- .regexpIgnoreCase(repDI[[2]])
  .datRegB <- paste("\\b", .datReg, "\\b")
  .typeReg <- .regexpIgnoreCase(repDI[[1]])
  .regIf <- paste0("^ *IF *[(]([^)]*", .datReg, "[^)]*)[)] *(.*)\\b",
                   .typeReg, " *[(] *", .datReg, " *[)] *(.*)$")

  .elt <- repDI[[3]]
  .prefix <- paste0("IF (", repDI[[2]], ".EQ.", seq_along(.elt), ") ")

  .w <- which(regexpr(.regIf, lines, perl=TRUE) != -1)
  if (length(.w) != 0) {
    lines <- strsplit(paste(vapply(seq_along(lines), function(.i) {
      .line <- lines[.i]
      if (!(.i %in% .w)) return(.line)
      # extract logical expression
      .lgl <- gsub(.regIf, "\\1", .line, perl=TRUE)
      # change data item to replacement value
      .lgl <- gsub(.datReg, ".i", .lgl, perl=TRUE)
      # now swap fortran logic for R logic
      .lgl <- gsub(.regexpIgnoreCase(".eq."), "==", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".ne."), "!=", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".lt."), "<", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".gt."), ">", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".le."), "<=", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".ge."), ">=", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".and."), "&&", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".or."), "||", .lgl)
      .lgl <-vapply(.elt, function(.i) {
        .ret <- try(eval(parse(text=.lgl)), silent=TRUE)
        if (inherits(.ret, "try-error")) return(NA)
        .ret
      }, logical(1), USE.NAMES=FALSE)
      if (any(is.na(.lgl))) {
        warning(paste0("line '", .line, "' logical expression cannot be determined with '", repDI[[2]], "' alone, ignoring ", toupper(repDI[[1]]), "(", repDI[[2]], ")"),
                call.=FALSE)
        return(.line)
      }
      .vec <- vapply(seq_along(.elt), function(.j) {
        paste0(.prefix[.j],
               gsub(.regIf, paste0("\\2", toupper(repDI[[1]]), "(", .elt[.j], ")", "\\3"),
                    .line, perl=TRUE))},
        character(1), USE.NAMES=FALSE)
      .vec <- .vec[.lgl]
      paste(.vec, collapse="\n")
    }, character(1), USE.NAMES=FALSE), collapse = "\n"), "\n")[[1]]
  }
  .reg <- paste0("\\b", .typeReg, " *[(] *", .datReg," *[)] *")
  .w <- which(regexpr(.reg, lines) != -1)
  if (length(.w) == 0) return(lines)
  strsplit(paste(vapply(seq_along(lines), function(.i) {
    .line <- lines[.i]
    if (!(.i %in% .w)) return(.line)
    if (regexpr("IF", .line) != -1) return(.line)
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
  .datReg <- .regexpIgnoreCase(repDVI[[2]])
  .datRegB <- paste("\\b", .datReg, "\\b")
  .typeReg <- .regexpIgnoreCase(repDVI[[1]])
  .varReg <- .regexpIgnoreCase(repDVI[[3]])
  .reg00 <- paste0("(?:",.datReg, "_", .varReg, "|", .varReg, "_", .datReg, ")")
  .reg0 <- paste0("\\b", .typeReg, " *[(] *", .reg00, " *[)] *")
  .reg <- paste0("^ *[A-Za-z][A-Za-z0-9_]* *=.*",  .reg0)

  .regIf <- paste0("^ *IF *[(]([^)]*", .datReg, "[^)]*)[)] *([A-Za-z][A-Za-z0-9_]* *=.*)",
                   .typeReg, " *[(] *", .reg00, " *[)] *(.*)$")
  .elt <- repDVI[[4]]
  .prefix <- paste0("IF (", repDVI[[2]], ".EQ.", seq_along(.elt), ") ")
  .w <- which(regexpr(.regIf, lines, perl=TRUE) != -1)
  if (length(.w) != 0) {
    lines <- strsplit(paste(vapply(seq_along(lines), function(.i) {
      .line <- lines[.i]
      if (!(.i %in% .w)) return(.line)
      # extract logical expression
      .lgl <- gsub(.regIf, "\\1", .line, perl=TRUE)
      # change data item to replacement value
      .lgl <- gsub(.datReg, ".i", .lgl, perl=TRUE)
      # now swap fortran logic for R logic
      .lgl <- gsub(.regexpIgnoreCase(".eq."), "==", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".ne."), "!=", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".lt."), "<", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".gt."), ">", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".le."), "<=", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".ge."), ">=", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".and."), "&&", .lgl)
      .lgl <- gsub(.regexpIgnoreCase(".or."), "||", .lgl)
      .lgl <-vapply(.elt, function(.i) {
        .ret <- try(eval(parse(text=.lgl)), silent=TRUE)
        if (inherits(.ret, "try-error")) return(NA)
        .ret
      }, logical(1), USE.NAMES=FALSE)
      if (any(is.na(.lgl))) {
        warning(paste0("line '", .line, "' logical expression cannot be determined with '", repDVI[[2]], "' alone, ignoring ", toupper(repDVI[[1]]), "(", repDVI[[2]], "_", repDVI[[3]], ")"),
                call.=FALSE)
        return(.line)
      }
      .vec <- vapply(seq_along(.elt), function(.j) {
        paste0(.prefix[.j],
               gsub(.regIf, paste0("\\2", toupper(repDVI[[1]]), "(", .elt[.j], ")", "\\3"),
                    .line, perl=TRUE))},
        character(1), USE.NAMES=FALSE)
      .vec <- .vec[.lgl]
      paste(.vec, collapse="\n")
    }, character(1), USE.NAMES=FALSE), collapse = "\n"), "\n")[[1]]
  }
  .w <- which(regexpr(.reg, lines) != -1)
  if (length(.w) == 0) return(lines)

  strsplit(paste(vapply(seq_along(lines), function(.i) {
    .line <- lines[.i]
    if (!(.i %in% .w)) return(.line)
    paste(vapply(seq_along(.elt), function(.j) {
      paste0(.prefix[.j],
             gsub(.reg0, paste0(toupper(repDVI[[1]]), "(", .elt[.j], ")"),
                  .line))
    }, character(1), USE.NAMES=FALSE), collapse = "\n")
  }, character(1), USE.NAMES=FALSE), collapse = "\n"), "\n")[[1]]


}
