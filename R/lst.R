.nmlst <- new.env(parent=emptyenv())
#' Reads the NONMEM `.lst` file for final parameter information
#'  
#' @param file File where the list is located
#' @return return a list with `$theta`, `$eta` and `$eps`
#' @export 
#' @author Matthew L. Fidler
#' @examples
#' nmlst(system.file("mods/DDMODEL00000322/HCQ1CMT.lst", package="nonmem2rx"))
#' nmlst(system.file("mods/DDMODEL00000302/run1.lst", package="nonmem2rx"))
#' nmlst(system.file("mods/DDMODEL00000301/run3.lst", package="nonmem2rx"))
nmlst <- function(file) {
  # run time
  # nmtran message
  .lst <- suppressWarnings(readLines(file))
  if (length(.lst) == 0) {
    stop("no lines read for file", call.= FALSE)
  }

  .nmtran <- NULL
  .reg <- "WARNINGS +AND +ERRORS +[(]IF +ANY[)] +FOR +PROBLEM"
  .w <- which(regexpr(.reg, .lst) != -1)
  if (length(.w) > 0) {
    .w <- .w[1]
    .w2 <- which(regexpr("License", .lst) != -1)
    if (length(.w2) > 0) {
      .w2 <- .w2[1]-1
      .nmtran <- .lst[seq(.w, .w2)]
      .w2 <- which(regexpr("^ *[*][*][*]*", .nmtran) != -1)
      if (length(.w2) > 0) {
        .w2 <- .w2[1]-1
        .nmtran <- .nmtran[seq_len(.w2-1)]
        while(regexpr("^ +$",.nmtran[length(.nmtran)]) != -1) {
          .nmtran <- .nmtran[-length(.nmtran)]
        }
      }
      .nmtran <- paste(.nmtran, collapse="\n")
    } else {
      .nmtran <- NULL
    }
  }

  .reg <- "^ *[#]TERM[:]"
  .w <- which(regexpr(.reg, .lst) != -1)
  .termInfo <- NULL
  if (length(.w) > 0) {
    .w <- .w[1]
    .termInfo <- .lst[-seq_len(.w)]
    .w <- which(.termInfo == "")
    .w <- .w[1] - 1
    .termInfo <- .termInfo[seq_len(.w)]
    .termInfo <- paste(.termInfo, collapse = "\n")
  }

  .reg <- ".*[(]NONMEM[)] +VERSION +"
  .w <- which(regexpr(.reg, .lst) != -1)
  .nonmem <- NULL
  if (length(.w) > 0) {
    .w <- .w[1]
    .nonmem <- sub(.reg, "", .lst[.w], )
  }
  .w <- which(regexpr("^ *[#]OBJV:", .lst) != -1)
  if (length(.w) == 0) {
    .obj <- NULL
  } else {
    .obj <- as.numeric(sub("[^*]*[*]+ *([^* ]*) *[*]*", "\\1",.lst[.w]))
  }
  .reg <- "TOT[.] +NO[.] +OF +OBS +RECS[:] +"
  .w <- which(regexpr(.reg, .lst) != -1)
  if (length(.w) == 0) {
    .nobs <- NULL
  } else {
    .nobs <- as.numeric(sub(.reg, "", .lst[.w]))
  }
  .reg <- "TOT[.] +NO[.] +OF +INDIVIDUALS[:] +"
  .w <- which(regexpr(.reg, .lst) != -1)
  if (length(.w) == 0) {
    .nsub <- NULL
  } else {
    .nsub <- as.numeric(sub(.reg, "", .lst[.w]))
  }
  .w <- which(regexpr("FINAL +PARAMETER +ESTIMATE", .lst) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .lst[seq(.w, length(.lst))]
  
  .w <- which(regexpr("(THETA +- +VECTOR|OMEGA +- +COV|SIGMA +- +COV)", .est) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .est[seq(.w, length(.est))]
  
  .w <- which(regexpr("^ *[*][*][*]+", .est) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .est[seq(1, .w - 1)]
  .est <- paste(.est, collapse="\n")
  .Call(`_nonmem2rx_trans_lst`, .est)

  ## run time
  list(theta=.nmlst$theta,
       omega=.nmlst$eta,
       sigma=.nmlst$eps,
       objf=.obj,
       nobs=.nobs,
       nsub=.nsub,
       nmtran=.nmtran,
       termInfo=.termInfo,
       nonmem=.nonmem)
}
#' Push final estimates
#'
#' @param type Type of element ("theta", "eta", "eps")
#' @param est R code for the estimates (need to apply names and lotri)
#' @param maxElt maximum number of the element type
#' @return nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushLst <- function(type, est, maxElt) {
  if (type == "theta") {
    assign("theta", setNames(eval(parse(text=est)), paste0(type,seq(1, maxElt))), envir=.nmlst)
  } else {
    .est <- paste0("lotri::lotri(",
                   paste(paste0(type, seq(1, maxElt)), collapse="+"),
                   " ~ ", est, ")")
    .est <- eval(parse(text=.est))
    assign(type, .est, envir=.nmlst)
  }
  invisible()
}
