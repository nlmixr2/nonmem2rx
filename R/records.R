.recordEnv <- new.env(parent=emptyenv())

.transRecords <-
  c(pro="pro", # $problem
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
  rm(ls(all=TRUE, envir=.recordEnv),
     envir=.recordEnv)
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
    .rec$.recs <- NULL
  }
  if (!(.rec %in% .rec$.recs)) {
    .rec$.recs <- c(.rec$.recs, .rec)
  }
  if (!exists(.rec, envir=.recordEnv)) {
    assign(.rec, NULL, envir=.recordEnv)
  }
  assign(.rec, c(get(.rec, envir=.recordEnv),
                 text), envir=.recordEnv)
  invisible()
}
