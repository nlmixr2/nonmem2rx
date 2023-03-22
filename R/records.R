.recordEnv <- new.env(parent=emptyenv())
.recordEnv$hasPro <- FALSE
.recordEnv$ignoreRec <- FALSE


.transRecords <-
  c("aaa"="aaa", # Triple A is before any record
    pro="pro", # $problem
    inp="inp", # $input
    ind="ind", # $index
    indxs="ind",
    con="con", # $contra
    dat="dat", # $data
    sub="sub", # $subroutines
    abb="abb", # $abbrevited
    pre="pre", # $pred
    the="the", # $theta
    thetap="thetap", #thetap
    thetapv="thetapv", # thetapv
    ome="ome", # $omega
    sig="sig", # $sigma
    msf="msf", # $msfi
    sim="sim", # $simulation
    est="est", # $estimation
    mix="mix", # $mixture
    estm="est",
    cov="cov", # $covariance
    tab="tab", # $table
    sca="sca", # $scatterplot
    mod="mod", # $model
    des="des", # $des
    pk="pk",   # $pk
    err="err", # $error
    bin="bin", # $bind
    aes="aes", # $aes
    aesinitial="aesi", # $aesinitial
    design="design", # $design
    tol="tol")

.transRecordsDisplay <-
  c(pro="$PROBLEM", # $problem
    inp="$INPUT", # $input
    ind="$INDEX", # $index
    indxs="$INDEX",
    con="$CONTRA", # $contra
    dat="$DATA", # $data
    sub="$SUBROUTINES", # $subroutines
    abb="$ABBREVITED", # $abbrevited
    pre="$PRED", # $pred
    the="$THETA", # $theta
    thetap="$THETAP", # $thetap
    thetapv="$THETAPV", # $thetapv
    ome="$OMEGA", # $omega
    sig="$SIGMA", # $sigma
    msf="$MSFI", # $msfi
    mix="$MIX",
    sim="$SIMULATION", # $simulation
    est="$ESTIMATION", # $estimation
    estm="$ESTIMATION",
    cov="$COVARIANCE", # $covariance
    tab="$TABLE", # $table
    sca="$SCATTERPLOT", # $scatterplot
    mod="$MODEL", # $model
    des="$DES", # $des
    pk="$PK",   # $pk
    err="$ERROR", # $error
    bin="$BIND", # $bind
    aes="$AES", # $aes
    design="$DESIGN",
    aesinitial="$AESINITIAL", # $aesinitial
    tol="$TOL")


#' Get the normalized NONMEM record name
#'
#' @param rec input record (excluding `$`)
#'
#' @return normalized NONMEM record name
#'
#' @noRd
#'
#' @examples
#'
#' .transRecord("THETA")
#'
.transRecord <- function(rec) {
  .rec <- tolower(rec)
  .ret <- .transRecords[.rec]
  if (is.na(.ret)) {
    if (.rec == "thetap") {
      .ret <- .transRecords[.rec]
    } else if (.rec == "thetapv") {
      .ret <- .transRecords[.rec]
    } else {
      .rec0 <- substr(.rec, 1, 3)
      .nchar <- nchar(.rec)
      if (.rec0 != "des" || (.rec0 == "des" && .nchar == 3)) {
        .ret <- .transRecords[.rec0]
      } else if (.rec0 == "des" && .nchar >= 4 && substr(.rec, 1, 4) == "desi") {
        .rec0 <- "design"
        .ret <- .transRecords[.rec0]
      }
    }
  }
  if (is.na(.ret)) return("")
  setNames(.ret, NULL)
}

#' Clear Record Environment
#'
#' @return Nothing, called for side effects
#' @noRd
#'
#' @examples
#'
#' .clearRecordEnv()
#'
.clearRecordEnv <- function() {
  .ls <- ls(all.names=TRUE, envir=.recordEnv)
  if (length(.ls) > 0L) rm(list=.ls,envir=.recordEnv)
  .recordEnv$hasPro <- FALSE
  .recordEnv$ignoreRec <- FALSE
}

#' Add record information for further conversion later
#'
#' @param rec Record text
#' @param text Text for the record
#'
#' @return Nothing called for side effects
#' @noRd
#'
#' @examples
#'
#' .addRec("OMEGA", "BLOCK(3) 6 .005 .0002 .3 .006 .4")
.addRec <- function(rec, text) {
  if (.recordEnv$ignoreRec) return(invisible())
  .rec <- .transRecord(rec)
  if (.rec == "pro") {
    if (.recordEnv$hasPro) {
      warning("multiple $PROBLEM statements; only use first $PROBLEM for translation",
              call.=FALSE)
      .recordEnv$ignoreRec <- TRUE
    } else {
      .recordEnv$hasPro <- TRUE
    }
  }
  # don't do anything with unknown records
  if (.rec == "") return(invisible())
  if (!exists(".recs", envir = .recordEnv)) {
    .recordEnv$.recs <- NULL
  }
  if (!(.rec %in% .recordEnv$.recs)) {
    .recordEnv$.recs <- c(.recordEnv$.recs, .rec)
  }
  if (!exists(.rec, envir=.recordEnv)) {
    assign(.rec, NULL, envir=.recordEnv)
  }
  assign(.rec, c(get(.rec, envir=.recordEnv),
                 text), envir=.recordEnv)
  invisible()
}
#' Parse the record and put in the record environment
#'
#'
#' @param ctl control stream
#' @return nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
#' @examples
#' .parseRec(paste(readLines(system.file("run001.mod", package="nonmem2rx")), collapse = "\n"))
.parseRec <- function(ctl) {
  checkmate::checkString(ctl)
  .clearRecordEnv()
  .minfo("splitting control stream by records")
  .recs <- strsplit(ctl, "(^|\\n) *[$]")[[1]]

  .addRec("aaa", .recs[1])
  lapply(.recs[-1], function(r) {
    .m <- regexpr("^ *[A-Za-z]+", r)
    if (.m != -1) {
      .rec <- substr(r, 1, attr(.m, "match.length"))
      .content <- substr(r, attr(.m, "match.length")+1, nchar(r))
      .addRec(.rec, .content)
    } else  {
      message(deparse1(r))
      stop("unexpected line", call. = FALSE)
    }
  })
  .minfo("done")
  .recs <- .recordEnv$.recs
  # process these records first to make sure abbreaviated code is
  # translated correctly
  .first <- c("inp", "abb", "mod", "the", "ome", "sig", "mix")
  for (.r in .first) {
    .w <- which(.recs == .r)
    if (length(.w) == 1L) {
      .ret <- get(.r, envir=.recordEnv)
      class(.ret) <- c(.r, "nonmem2rx")
      nonmem2rxRec(.ret)
      .recs <- .recs[-.w]
    }
  }
  # Replace the abbreaviated code before processing
  .replaceAbbrev()
  # process the rest of the code
  for(.r in .recs) {
    .ret <- get(.r, envir=.recordEnv)
    class(.ret) <- c(.r, "nonmem2rx")
    ## print(.ret)
    nonmem2rxRec(.ret)
  }
}
#' Record handling for nonmem records
#'
#' @param x Nonmem record data item, should be of class c(stdRec,
#'   "nonmem2rx") where the stdRec is the standardized record (pro for
#'   `$PROBLEM`, etc)
#' @return Nothing, called for side effects
#' @details
#'
#' Can add record parsing and handling by creating a S3 method for each type of standardized method
#'
#' @export
#' @author Matthew L. Fidler
#' @keywords internal
nonmem2rxRec <- function(x) {
  if (!inherits(x , "nonmem2rx")) {
    print(x)
    stop("record not from nonmem2rx", call.=FALSE)
  }
  .a <- class(x)[1]
  if (.a == "aaa") {
    .Call(`_nonmem2rx_setRecord`, "Text before $PROBLEM")
    UseMethod("nonmem2rxRec")
  } else {
    .rec <- .transRecordsDisplay[class(x)[1]]
    .Call(`_nonmem2rx_setRecord`, .rec)
    .minfo(sprintf("Processing record %s", .rec))
    .ret <- UseMethod("nonmem2rxRec")
    .minfo("done")
    .ret
  }
}

#' @rdname nonmem2rxRec
#' @export
nonmem2rxRec.default <- function(x) {
  .minfo(sprintf("Ignore record %s", .transRecordsDisplay[class(x)[1]]))
  invisible()
}
