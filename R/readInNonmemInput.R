#' Read in data frame nonmem input file
#'
#' This requires the parsing environment setup
#'  
#' @param file this is the file name of the control stream
#' @return dataset (as nonmem sees it), where all ignore, accept, and
#'   records adjustment are done. If the model calls evid in it, it
#'   also adds a nmevid column
#' @noRd
#' @author Matthew L. Fidler
.readInDataFromNonmem <- function(file) {
  .data <- NULL
  .file <- .getFileNameIgnoreCase(file.path(dirname(file), .nonmem2rx$dataFile))
  .ext <- tools::file_ext(.file)
  if (.ext == "csv" && file.exists(.file)) {
    .minfo(paste0("read in nonmem input data (for model validation): ", .file))
    .data <- read.csv(.file, row.names=NULL, na.strings=c("NA", "."))
    if (!is.null(.nonmem2rx$dataIgnore1)) {
      if (.nonmem2rx$dataIgnore1 == "@") {
        .minfo("ignoring lines that begin with a letter (IGNORE=@)'")
        .w <- which(regexpr("^[A-Za-z]", .data[,1]) != -1)
        if (length(.w) > 0) .data <- .data[-.w, ]
      } else {
        .minfo(paste0("ignoring lines that begin with '", .nonmem2rx$dataIgnore1, "'"))
        .w <- which(.data[,1] == .nonmem2rx$dataIgnore1)
        if (length(.w) > 0) .data <- .data[-.w, ]
      }
    }
    .minfo("applying names specified by $INPUT")
    # need to apply input names
    # 1. Only work with columns specified in $input
    .inp <- .nonmem2rx$input
    .data <- .data[,seq_along(.inp)]
    # 2. drop values requested by nonmem
    names(.data) <- names(.nonmem2rx$input)
    .w <- which(.inp == "DROP")
    if (length(.w) > 0) {
      .inp <- .inp[-.w]
      .data <- .data[, -.w]
    }
    # 3. add nonmem declared aliases into the dataset
    .w <- which(names(.inp) != .inp)
    if (length(.w) > 0) {
      .inpr <- .inp[.w]
      for (.i in names(.inpr)) {
        .data[, .inpr[.i]] <- .data[, .i]
      }
    }
    # https://www.mail-archive.com/nmusers@globomaxnm.com/msg05323.html
    if (length(.nonmem2rx$dataCond) > 0) {
      .cond <- paste0("-which(",
                     ifelse(.nonmem2rx$dataCondType == "accept", "!", ""), "(",
                     paste(.nonmem2rx$dataCond, collapse=" || "),
                     "))")
      .minfo(paste0("subsetting accept/ignore filters code: .data[", .cond, ",]"))
      .w <- eval(parse(text=.cond))
      if (length(.w) > 0) {
        .data <- .data[.w,]
      }
    }
    if (.nonmem2rx$needNmevid) {
      .minfo("adding nmevid to dataset")
      .data$nmevid <- .data[, which(tolower(names(.data)) == "evid")]
    }
    # I don't use, records=#, but my reading is this is a filter after the ignore/accept statements
    if (!is.na(.nonmem2rx$dataRecords)) {
      .minfo(sprintf("subsetting to %d records after filters", .nonmem2rx$dataRecords))
      .data <- .data[seq_len(.nonmem2rx$dataRecords), ]
    }
  }
  .minfo("done")
  .data
}
#' This reads in the nonmem output file that has the ipred data in it
#'  
#' @param file nonmem control stream file name
#' @return dataset that has nonmem ipred data for validation
#' @noRd
#' @author Matthew L. Fidler
.readInIpredFromTables <- function(file) {
  .w <- which(vapply(seq_along(.nonmem2rx$tables),
                     function(i) {
                       .table <- .nonmem2rx$tables[[i]]
                       if (!.table$fullData) return(FALSE)
                       if (!.table$hasIpred) return(FALSE)
                       .file <- .getFileNameIgnoreCase(file.path(dirname(file), .table$file))
                       if (!file.exists(.file)) return(FALSE)
                       TRUE
                     }, logical(1), USE.NAMES=FALSE))
  if (length(.w) == 0) return(NULL)
  .w <- .w[1]
  .table <- .nonmem2rx$tables[[.w]]
  .file <- .getFileNameIgnoreCase(file.path(dirname(file), .table$file))
  .minfo(paste0("read in nonmem IPRED data (for model validation): ", .file))
  #.ret <- pmxTools::read_nm_multi_table(.file)
  .ret <- nmtab(.file)
  .w <- which(names(.ret) == "IPRE")
  if (length(.w) > 0) names(.ret)[.w] <- "IPRED"
  .minfo("done")
  .ret
}
#'  Get and normalize path (if exists or exists in a case insensitive way)
#'  
#' @param path path to normalize 
#' @return normalized case sensitive path
#' @noRd
#' @author Matthew L. Fidler
.getFileNameIgnoreCase <- function(path) {
  if (file.exists(path)) return(normalizePath(path))
  .dirname <- dirname(path)
  .basename <- basename(path)
  .files <- list.files(.dirname)
  .w <- which(tolower(.basename)==tolower(.files))
  if (length(.w) != 1) return(path)
  normalizePath(file.path(.dirname, .files[.w]))
}

#' Read in the ipred data from nonmem output
#'  
#' @param file nonmem control stream name
#' @return pred data file or null if it doesn't exist or isn't available
#' @noRd
#' @author Matthew L. Fidler
.readInPredFromTables <- function(file) {
  .w <- which(vapply(seq_along(.nonmem2rx$tables),
                     function(i) {
                       .table <- .nonmem2rx$tables[[i]]
                       if (!.table$fullData) return(FALSE)
                       if (!.table$hasPred) return(FALSE)
                       .file <- .getFileNameIgnoreCase(file.path(dirname(file), .table$file))
                       if (!file.exists(.file)) return(FALSE)
                       TRUE
                     }, logical(1), USE.NAMES=FALSE))
  if (length(.w) == 0) return(NULL)
  .w <- .w[1]
  .table <- .nonmem2rx$tables[[.w]]
  .file <- .getFileNameIgnoreCase(file.path(dirname(file), .table$file))
  .minfo(paste0("read in nonmem PRED data (for model validation): ", .file))
  #.ret <- pmxTools::read_nm_multi_table(.file)
  .ret <- nmtab(.file)
  .minfo("done")
  .ret
}

#' Read in the etas from the nonmem dataest
#'  
#' @param file control stream name
#' @return etas renamed to be lower case with IDs added
#' @noRd
#' @author Matthew L. Fidler
.readInEtasFromTables <- function(file) {
  .w <- which(vapply(seq_along(.nonmem2rx$tables),
                     function(i) {
                       .table <- .nonmem2rx$tables[[i]]
                       if (!.table$hasEta) return(FALSE)
                       .file <- .getFileNameIgnoreCase(file.path(dirname(file), .table$file))
                       if (!file.exists(.file)) return(FALSE)
                       TRUE
                     }, logical(1), USE.NAMES=FALSE))
  if (length(.w) == 0) return(NULL)
  .w <- .w[1]
  .table <- .nonmem2rx$tables[[.w]]
  .file <- .getFileNameIgnoreCase(file.path(dirname(file), .table$file))
  .minfo(paste0("read in nonmem ETA data (for model validation): ", .file))
  .ret <- nmtab(.file)
  if (.table$fullData) {
    .ret <- .ret[!duplicated(.ret$ID),]
  }
  .w <- which(regexpr("^(ID|ETA.*)", names(.ret)) != -1)
  .ret <- .ret[,.w]
  names(.ret)[-1] <- tolower(names(.ret)[-1])
  .minfo("done")
  .ret
}
