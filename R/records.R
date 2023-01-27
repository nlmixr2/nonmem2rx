.recordEnv <- new.env(parent=emptyenv())

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
    ome="ome", # $omega
    sig="sig", # $sigma
    msf="msf", # $msfi
    sim="sim", # $simulation
    est="est", # $estimation
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
    tol="tol")

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
    .rec <- substr(.rec, 1, 3)
    .ret <- .transRecords[.rec]
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
  .rec <- .transRecord(rec)
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
  .Call(`_nonmem2rx_trans_records`, ctl)
  for(.r in .recordEnv$.recs) {
    .ret <- get(.r, envir=.recordEnv)
    class(.ret) <- c(.r, "nonmem2rx")
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
  UseMethod("nonmem2rxRec")
}

#' @rdname nonmem2rxRec
#' @export
nonmem2rxRec.default <- function(x) {
  invisible()
}
