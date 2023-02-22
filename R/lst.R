.nmlst <- new.env(parent=emptyenv())
.nmlst.control <- 1L
.nmlst.nmtran  <- 2L
.nmlst.version <- 3L
.nmlst.nobs    <- 4L
.nmlst.nsub    <- 5L
.nmlst.term    <- 6L
.nmlst.tere    <- 7L
.nmlst.obj     <- 8L
.nmlst.est     <- 9L
.nmlst.cov     <- 10L
.nmlst.end     <- 12L

.nmlstControl <- function(line) {
  if (.nmlst$section == .nmlst.control) {
    # search for control stream, typically found at the beginning of the file
    if (is.null(.nmlst$control)) {
      .begin <- "^ *([$][Pp][Rr][Oo]| *;.*)"
      if (grepl(.begin, line)) {
        .nmlst$control <- line
      }
      return(NULL)
    }
    .end <- "^( *NM-TRAN +MESSAGES *$| *1NONLINEAR *MIXED|License +Registered +to: +| *[*][*][*][*][*]*)"
    if (grepl(.end, line)) {
      .nmlst$section <- .nmlst.nmtran
    } else {
      .nmlst$control <- c(.nmlst$control, line)
      return(NULL)
    }
  }
  .nmlst$section
}

.nmlstNmtran <- function(line) {
  if (.nmlst$section == .nmlst.nmtran) {
    if (is.null(.nmlst$nmtran)) {
      .begin <- "WARNINGS AND ERRORS (IF ANY) FOR PROBLEM"
      if (grepl(.begin, line, fixed =TRUE)) {
        .nmlst$nmtran <- line
      }
      return(NULL)
    }
    .end <- "(License|^ *[*][*][*]*|[(]NONMEM[)] VERSION)"
    if (grepl(.end, line)) {
      while(grepl("^ *$",.nmlst$nmtran[length(.nmlst$nmtran)])) {
        .nmlst$nmtran <- .nmlst$nmtran[-length(.nmlst$nmtran)]
      }
      .nmlst$nmtran <- paste(.nmlst$nmtran, collapse="\n")
      .nmlst$section <- .nmlst.version
    } else {
      .nmlst$nmtran <- c(.nmlst$nmtran, line)
      return(NULL)
    }
  }
  return(.nmlst$section)
}

.nmlstVersion <- function(line) {
  if (.nmlst$section == .nmlst.version) {
    .begin <- ".*[(]NONMEM[)] +VERSION +"
    if (grepl(.begin, line)) {
      .nmlst$nonmem <- sub(.begin, "", line)
      .nmlst$section <- .nmlst.nobs
      return(NULL)
    } else if (grepl("TOT. NO. OF OBS RECS:", line, fixed=TRUE)){
      .nmlst$section <- .nmlst.nobs
    } else {
      return(NULL)
    }
  }
  .nmlst$section
}
.nmlstNobs <- function(line) {
  if (.nmlst$section == .nmlst.nobs) {
    if (grepl("TOT. NO. OF OBS RECS:", line, fixed=TRUE)) {
      .nmlst$nobs <- as.numeric(sub("TOT. NO. OF OBS RECS:", "", line, fixed=TRUE))
      .nmlst$section <- .nmlst.nsub
      return(NULL)
    } else if (grepl("TOT. NO. OF INDIVIDUALS:", line, fixed=TRUE)) {
      .nmlst$section <- .nmlst.nsub
    } else {
      return(NULL)
    }
  }
  .nmlst$section
}

.nmlstNsub <- function(line) {
  # Number of subjects
  if (.nmlst$section == .nmlst.nsub) {
    if (grepl("TOT. NO. OF INDIVIDUALS:", line, fixed=TRUE)) {
      .nmlst$nsub <- as.numeric(sub("TOT. NO. OF INDIVIDUALS:", "", line, fixed = TRUE))
      .nmlst$section <- .nmlst.term
      return(NULL)
    } else if (grepl("#TERM:", line, fixed=TRUE)) {
      .nmlst$section <- .nmlst.term
    } else {
      return(NULL)
    }
  }
  .nmlst$section
}

.nmlstTerm <- function(line) {
  if (.nmlst$section == .nmlst.term) {
    if (!.nmlst$term && grepl("#TERM:", line, fixed=TRUE)) {
      .nmlst$term <- TRUE
      return(NULL)
    } else if (.nmlst$term && grepl("^ *$",line)) {
      .nmlst$termInfo <- paste(.nmlst$termInfo, collapse="\n")
      .nmlst$section <- .nmlst.tere
      return(NULL)
    } else if (.nmlst$term) {
      .nmlst$termInfo <- c(.nmlst$termInfo, line)
      return(NULL)
    }
  }
  .nmlst$section
}

.nmlstTere  <- function(line) {
  if (.nmlst$section == .nmlst.tere) {
    if (!.nmlst$tere && grepl("#TERE:", line, fixed=TRUE)) {
      .nmlst$tere <- TRUE
      return(NULL)
    } else if (.nmlst$tere) {
      if (grepl("^ *1 *$", line)) {
        .nmlst$tere <- paste(.nmlst$time, collapse="\n")
        .w <- which(regexpr(":", .nmlst$time) != -1)
        if (length(.w) > 0) {
          .nmlst$time <- .nmlst$time[.w]
          .nmlst$time <- sum(as.numeric(gsub(".*: +", "", .nmlst$time)))
        } else {
          .nmlst$time <- NULL
        }
        .nmlst$section <- .nmlst.obj
        return(NULL)
      } else if (.nmlst$tere && grepl("#OBJV:", line, fixed=TRUE)) {
        .nmlst$section <- .nmlst.obj
      } else if (.nmlst$tere) {
        .nmlst$time <- c(.nmlst$time, line)
        return(NULL)
      }
    }
  }
  .nmlst$section
}

.nmlstObj  <- function(line) {
  if (.nmlst$section == .nmlst.obj) {
    if (grepl("#OBJV:", line, fixed=TRUE)) {
      .nmlst$obj <- as.numeric(sub("[^*]*[*]+ *([^* ]*) *[*]*", "\\1", line))
      .nmlst$section <- .nmlst.est
      return(NULL)
    } else if (grepl("FINAL PARAMETER ESTIMATE", line, fixed=TRUE)) {
      .nmlst$section <- .nmlst.est
    } else {
      return(NULL)
    }
  }
  .nmlst$section
}

.nmlstEst <- function(line) {
  if (.nmlst$section == .nmlst.est) {
    if (!.nmlst$isEst && grepl("FINAL PARAMETER ESTIMATE", line, fixed=TRUE)) {
      .nmlst$isEst <- TRUE
      return(NULL)
    } else if (is.null(.nmlst$est) &&
                 .nmlst$isEst && grepl("(THETA +- +VECTOR|OMEGA +- +COV|SIGMA +- +COV)", line)) {
      .nmlst$est <- line
      return(NULL)
    } else if (!is.null(.nmlst$est) &&
                 grepl("COVARIANCE MATRIX OF ESTIMATE", line, fixed=TRUE)) {
      .est <- paste(.nmlst$est, collapse="\n")
      if (.nmlst$strictLst) {
        .Call(`_nonmem2rx_trans_lst`, .est, FALSE)
      } else {
        try(.Call(`_nonmem2rx_trans_lst`, .est, FALSE), silent=TRUE)
      }
      .nmlst$section <- .nmlst.cov
    } else if (!is.null(.nmlst$est) &&
                 grepl("^ *([*][*][*]+|Elapsed|[#]|PROBLEM +NO)", line)) {
      .est <- paste(.nmlst$est, collapse="\n")
      if (.nmlst$strictLst) {
        .Call(`_nonmem2rx_trans_lst`, .est, FALSE)
      } else {
        try(.Call(`_nonmem2rx_trans_lst`, .est, FALSE), silent=TRUE)
      }
      .nmlst$section <- .nmlst.cov
      return(NULL)
    } else if (!is.null(.nmlst$est)) {
      .nmlst$est <- c(.nmlst$est, line)
      return(NULL)
    }
  }
  .nmlst$section
}

.nmlstCov <- function(line) {
  if (.nmlst$section == .nmlst.cov) {
    if (!.nmlst$isCov && grepl("COVARIANCE MATRIX OF ESTIMATE", line, fixed=TRUE)) {
      .nmlst$isCov <- TRUE
      return(NULL)
    } else if (.nmlst$isCov &&
                 grepl("^ *(1 *$|CORRELATION MATRIX OF ESTIMATE|Elapsed|[#]|PROBLEM +NO|R MATRIX)", line)) {
      .nmlst$section <- .nmlst.end
      return(NULL)
    } else if (.nmlst$isCov && grepl("********", line, fixed=TRUE)) {
    } else if (.nmlst$isCov) {
      .nmlst$covEst <- c(.nmlst$covEst, line)
    } else {
      ## print(line)
    }
  }
  .nmlst$secton
}

.nmlst.fun <- function(line) {
  if (is.null(.nmlstControl(line))) return(NULL)
  if (is.null(.nmlstNmtran(line))) return(NULL)
  if (is.null(.nmlstVersion(line))) return(NULL)
  if (is.null(.nmlstNobs(line))) return(NULL)
  if (is.null(.nmlstNsub(line))) return(NULL)
  if (is.null(.nmlstTerm(line))) return(NULL)
  if (is.null(.nmlstTere(line))) return(NULL)
  if (is.null(.nmlstObj(line))) return(NULL)
  if (is.null(.nmlstEst(line))) return(NULL)
  if (is.null(.nmlstCov(line))) return(NULL)
  # final parameter estimates

  # covariance

  return(NULL)

}
#' Reads the NONMEM `.lst` file for final parameter information
#'
#' @param file File where the list is located
#' @return return a list with `$theta`, `$eta` and `$eps` and other
#'   information about the control stream
#' @inheritParams nonmem2rx
#' @export
#' @author Matthew L. Fidler
#' @examples
#' nmlst(system.file("mods/DDMODEL00000322/HCQ1CMT.lst", package="nonmem2rx"))
#' nmlst(system.file("mods/DDMODEL00000302/run1.lst", package="nonmem2rx"))
#' nmlst(system.file("mods/DDMODEL00000301/run3.lst", package="nonmem2rx"))
#' nmlst(system.file("mods/cpt/runODE032.res", package="nonmem2rx"))
nmlst <- function(file, strictLst=FALSE) {
  # run time
  # nmtran message
  if (length(file) == 1L) {
    .lst <- suppressWarnings(readLines(file))
  } else {
    .lst <-file
  }
  if (length(.lst) == 0) {
    stop("no lines read for file", call.= FALSE)
  }
  .nmlst$strictLst <- strictLst
  .nmlst$section <- .nmlst.control

  .nmlst$control <- NULL
  .nmlst$nmtran <- NULL
  .nmlst$nonmem <- NULL
  .nmlst$nobs <- NULL
  .nmlst$nsub <- NULL
  .nmlst$time <- NULL
  .nmlst$termInfo <- NULL
  .nmlst$obj <- NULL
  .nmlst$est <- NULL
  .nmlst$covEst <- NULL
  .nmlst$tere <- NULL


  .nmlst$theta <- NULL
  .nmlst$eta <- NULL
  .nmlst$sigma <- NULL
  .nmlst$cov <- NULL

  .nmlst$term <- FALSE
  .nmlst$tere <- FALSE
  .nmlst$isEst <- FALSE
  .nmlst$isCov <- FALSE

  lapply(.lst, .nmlst.fun)

  if (!is.null(.nmlst$covEst)) {
    .cov <- paste(.nmlst$covEst, collapse="\n")
    if (.nmlst$strictLst) {
      .Call(`_nonmem2rx_trans_lst`, .cov, TRUE)
    } else {
      try(.Call(`_nonmem2rx_trans_lst`, .cov, TRUE), silent=TRUE)
    }
  }

  ## run time
  list(theta=.nmlst$theta,
       omega=.nmlst$eta,
       sigma=.nmlst$eps,
       cov=.nmlst$cov,
       objf=.nmlst$obj,
       nobs=.nmlst$nobs,
       nsub=.nmlst$nsub,
       nmtran=.nmlst$nmtran,
       termInfo=.nmlst$termInfo,
       nonmem=.nmlst$nonmem,
       time=.nmlst$time,
       tere=.nmlst$tere,
       control=.nmlst$control)
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
  if (type == "cov") {
    .est <- eval(parse(text=paste0("c(",est)))
    .n <- names(.nmlst$theta)
    .ln <- length(.n)
    if (length(.est) == .ln*(.ln+1)/2) {
      .nmlst$eta <- NULL
      .nmlst$eps <- NULL
      .nmlst$cov <- eval(parse(text=paste0("lotri::lotri(",
                                           paste(.n, collapse="+"),
                                           " ~ ", deparse1(.est), ")")))
      return(invisible())
    }
    .d <- dim(.nmlst$eta)[1]
    for (.i in seq_len(.d)) {
      for(.j in seq(.i, .d)) {
        if (.i == .j) {
          .n <- c(.n, paste0("eta", .i))
        } else {
          .n <- c(.n, paste0("omega.", .i, ".", .j))
        }
      }
    }
    .ln <- length(.n)
    if (length(.est) == .ln*(.ln+1)/2) {
      .nmlst$eps <- NULL
      .nmlst$cov <- eval(parse(text=paste0("lotri::lotri(",
                                           paste(.n, collapse="+"),
                                           " ~ ", deparse1(.est), ")")))
      return(invisible())
    }
    .d <- dim(.nmlst$eps)[1]
    for (.i in seq_len(.d)) {
      for (.j in seq(.i, .d)) {
        if (.i == .j) {
          .n <- c(.n, paste0("eps", .i))
        } else {
          .n <- c(.n, paste0("sigma.", .i, ".", .j))
        }
      }
    }
    .ln <- length(.n)
    if (length(.est) == .ln*(.ln+1)/2) {
      .est <- paste0("lotri::lotri(",
                     paste(.n, collapse="+"),
                     " ~ ", deparse1(.est), ")")
      .nmlst$cov <- eval(parse(text=.est))
    }
  } else if (type == "theta") {
    assign("theta", setNames(eval(parse(text=est)), paste0(type,seq(1, maxElt))), envir=.nmlst)
  } else {
    .est <- eval(parse(text=est))
    if (length(.est) == maxElt*(maxElt+1)/2) {
      .est <- paste0("lotri::lotri(",
                     paste(paste0(type, seq(1, maxElt)), collapse="+"),
                     " ~ ", est, ")")
      .est <- eval(parse(text=.est))
      assign(type, .est, envir=.nmlst)
    }
  }
  invisible()
}
