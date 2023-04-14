#' Read in data frame nonmem input file
#'
#' This requires the parsing environment setup
#'  
#' @param file this is the file name of the control stream
#' @param inputData is a flag to use a different input data than
#'   `file`.  This is the user-specified input data.
#' @param rename rename parameters
#' @param delta Delta offset for ties
#' @param scanLines number of lines to scan before meeting the first data row (default 50)
#' @return dataset (as nonmem sees it), where all ignore, accept, and
#'   records adjustment are done. If the model calls evid in it, it
#'   also adds a nmevid column
#' @noRd
#' @author Matthew L. Fidler
.readInDataFromNonmem <- function(file, inputData, rename=NULL, delta=1e-4,
                                  scanLines=50L) {
  .data <- NULL
  if (is.null(inputData)) {
    .file <- .getFileNameIgnoreCase(file.path(dirname(file), .nonmem2rx$dataFile))
  } else {
    .file <- inputData
  }
  .ext <- tools::file_ext(.file)
  if (.ext == "csv" && file.exists(.file)) {
    .minfo(paste0("read in nonmem input data (for model validation): ", .file))
    if (!is.null(.nonmem2rx$dataIgnore1)) {
      .lines <- readLines(.file,n=scanLines)
      if (.nonmem2rx$dataIgnore1 == "@") {
        .minfo("ignoring lines that begin with a letter (IGNORE=@)'")
        .skip <- 0L
        while (.skip != scanLines - 1L && grepl("^[A-Za-z]", .lines[.skip+1L])) {
          .skip <- .skip+1L
        }
        .data <- read.csv(.file, row.names=NULL, na.strings=c("NA", "."), header=FALSE,
                          skip=.skip)
        .w <- which(regexpr("^[A-Za-z]", .data[,1]) != -1)
        if (length(.w) > 0) .data <- .data[-.w, ]
      } else {
        .minfo(paste0("ignoring lines that begin with '", .nonmem2rx$dataIgnore1, "'"))
        .data <- read.csv(.file, row.names=NULL, na.strings=c("NA", "."), header=FALSE,
                          comment.char=.nonmem2rx$dataIgnore1)
        .w <- which(.data[,1] == .nonmem2rx$dataIgnore1)
        if (length(.w) > 0) .data <- .data[-.w, ]
      }
    } else {
      .data <- read.csv(.file, row.names=NULL, na.strings=c("NA", "."), header=FALSE)
    }
    
    .minfo("applying names specified by $INPUT")
    # need to apply input names
    # 1. Only work with columns specified in $input
    .inp <- .nonmem2rx$input
    if (length(.data) < length(.inp)) {
      .inp <- .inp[seq_along(.data)]
    }
    .data <- .data[,seq_along(.inp)]
    # 2. drop values requested by nonmem
    names(.data) <- names(.inp)
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
                     paste(.nonmem2rx$dataCond, collapse=" | "),
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
    if (.nonmem2rx$needNmid) {
      .minfo("adding nmid to dataset")
      .data$nmid <- .data[, which(tolower(names(.data)) == "id")]
    }
    if (.nonmem2rx$needYtype) {
      .minfo("renaming 'ytype' to 'nmytype'")
      .wyt <- which(tolower(names(.data)) == "ytype")
      names(.data)[.wyt] <- "nmytype"
    }
    # I don't use, records=#, but my reading is this is a filter after the ignore/accept statements
    if (!is.na(.nonmem2rx$dataRecords)) {
      .minfo(sprintf("subsetting to %d records after filters", .nonmem2rx$dataRecords))
      .data <- .data[seq_len(.nonmem2rx$dataRecords), ]
    }
  }
  if (!is.null(rename) && !is.null(names(.data))) {
    names(.data) <- vapply(names(.data),
                           function(x) {
                             .w <- which(x == rename)
                             if (length(.w) == 1) return(names(rename)[.w])
                             x
                           }, character(1), USE.NAMES=FALSE)
  }
  .minfo("done")
  .fixNonmemTies(.data, delta)
}
#' This reads in the nonmem output file that has the ipred data in it
#'  
#' @param file nonmem control stream file name
#' @inheritParams nonmem2rx
#' @return dataset that has nonmem ipred data for validation
#' @noRd
#' @author Matthew L. Fidler
.readInIpredFromTables <- function(file, nonmemOutputDir=NULL, rename=NULL) {
  if (is.null(nonmemOutputDir)) {
    .dir <- dirname(file)    
  } else {
    .dir <- nonmemOutputDir
  }
  .w <- which(vapply(seq_along(.nonmem2rx$tables),
                     function(i) {
                       .table <- .nonmem2rx$tables[[i]]
                       if (!.table$fullData) return(FALSE)
                       if (!.table$hasIpred) return(FALSE)
                       .file <- file.path(.dir, .table$file)
                       .file <- .getFileNameIgnoreCase(.file)
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
  if (is.null(.ret)) return(NULL)
  .w <- which(names(.ret) == "IPRE")
  if (length(.w) > 0) names(.ret)[.w] <- "IPRED"
  if (!is.null(rename) && !is.null(names(.ret))) {
    names(.ret) <- vapply(names(.ret),
                           function(x) {
                             .w <- which(x == rename)
                             if (length(.w) == 1) return(names(rename)[.w])
                             x
                           }, character(1), USE.NAMES=FALSE)
  }
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
.readInPredFromTables <- function(file, nonmemOutputDir=NULL, rename=NULL) {
  if (is.null(nonmemOutputDir)) {
    .dir <- dirname(file)    
  } else {
    .dir <- nonmemOutputDir
  }
  .w <- which(vapply(seq_along(.nonmem2rx$tables),
                     function(i) {
                       .table <- .nonmem2rx$tables[[i]]
                       if (!.table$fullData) return(FALSE)
                       if (!.table$hasPred) return(FALSE)
                       .file <- .getFileNameIgnoreCase(file.path(.dir, .table$file))
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
  if (is.null(.ret)) return(NULL)
  if (!is.null(rename) && !is.null(names(.ret))) {
    names(.ret) <- vapply(names(.ret),
                          function(x) {
                            .w <- which(x == rename)
                            if (length(.w) == 1) return(names(rename)[.w])
                            x
                          }, character(1), USE.NAMES=FALSE)
  }
  .minfo("done")
  .ret
}

#' Read in the etas from the nonmem dataest
#'  
#' @param file control stream name
#' @param nonmemData represents the input nonmem data
#' @param rxModel represents the classic `rxode2` simulation model
#'   that will be run for validation
#' @return etas renamed to be lower case with IDs added
#' @noRd
#' @author Matthew L. Fidler
.readInEtasFromTables <- function(file, nonmemData, rxModel, nonmemOutputDir=NULL, rename=NULL,
                                  digits=0L) {
  if (is.null(nonmemOutputDir)) {
    .dir <- dirname(file)    
  } else {
    .dir <- nonmemOutputDir
  }
  .etaLab1 <- paste0("ETA(", .nonmem2rx$etaNonmemLabel, ")")
  .etaLab2 <- vapply(paste0("ET_", .nonmem2rx$etaNonmemLabel),
                     function(i) {
                       .nc <- min(nchar(i), 9L)
                       substr(i, 1, .nc)
                     }, character(1), USE.NAMES=FALSE)
  .etaLab2t <- .etaLab2[.etaLab2 != "ET_"]
  if (length(.etaLab2t) != 0) {
    if (any(duplicated(.etaLab2))) {
      .minfo("duplicate eta labels, can't read etas from output tables")
      return(NULL)
    }
  }

  .w <- which(vapply(seq_along(.nonmem2rx$tables),
                     function(i) {
                       .table <- .nonmem2rx$tables[[i]]
                       if (!.table$hasEta) return(FALSE)
                       if (.table$digits <= digits) return(FALSE) # may already have a better solution.
                       .file <- .getFileNameIgnoreCase(file.path(.dir, .table$file))
                       if (!file.exists(.file)) return(FALSE)
                       TRUE
                     }, logical(1), USE.NAMES=FALSE))
  if (length(.w) == 0) return(NULL)
  .w <- .w[1]
  .table <- .nonmem2rx$tables[[.w]]
  .file <- .getFileNameIgnoreCase(file.path(dirname(file), .table$file))
  .minfo(paste0("read in nonmem ETA data (for model validation): ", .file))
  .ret <- nmtab(.file)
  if (is.null(.ret)) return(NULL)
  if (.table$fullData) {
    .ret <- .ret[!duplicated(.ret$ID),]
  }
  .w <- which(regexpr("^(ID|ET)", names(.ret)) != -1)
  if (length(.w) <= 1) return(NULL)
  .ret <- .ret[,.w, drop=FALSE]
  # here drop any etas that are non influential
  .ret <- .getValidationEtas(.ret, nonmemData, rxModel)
  if (!is.null(rename) && !is.null(names(.ret))) {
    names(.ret) <- vapply(names(.ret),
                          function(x) {
                            # change nonmem 7.5 labels to ETA#
                            .w <- which(x == .etaLab1)
                            if (length(.w) == 1L) x <- paste0("ETA", .w)
                            .w <- which(x == .etaLab2)
                            if (length(.w) == 1L) x <- paste0("ETA", .w)
                            # rename if needed
                            .w <- which(x == rename)
                            if (length(.w) == 1) return(names(rename)[.w])
                            x
                          }, character(1), USE.NAMES=FALSE)
  }
  names(.ret)[-1] <- tolower(names(.ret)[-1])
  .minfo("done")
  .ret
}
