#' Get a compact R function text representation of a nonmem2rx model for LLM context
#'
#' @param nm2rx nonmem2rx/rxUI object
#' @return character string of the model function without metadata lines
#' @noRd
#' @author Matthew L. Fidler
.getCleanModelText <- function(nm2rx) {
  .fn  <- as.function(nm2rx)
  .txt <- deparse(.fn)
  .drop <- grepl("thetaMat|^\\s+sigma\\s*<-|dfObs|dfSub|description", .txt)
  paste(.txt[!.drop], collapse = "\n")
}

#' Use an LLM to determine the residual error structure for a nonmem2rx model
#'
#' @param nm2rx nonmem2rx object lacking `$predDf`
#' @param chat ellmer chat object; if NULL a default `ellmer::chat_claude()` is created
#' @param maxAttempts maximum number of LLM validation attempts
#' @param verbose logical, passed through for future use
#' @param ... additional arguments (unused)
#' @return decompressed rxUI with error structure added and validated, or NULL on failure
#' @noRd
#' @author Matthew L. Fidler
.llmDetermineError <- function(nm2rx, chat=NULL, maxAttempts=3, verbose=FALSE, ...) {
  if (!requireNamespace("ellmer", quietly=TRUE)) {
    stop("package 'ellmer' is required for LLM-assisted error detection; ",
         "install with: install.packages('ellmer')", call.=FALSE)
  }

  if (is.null(chat)) chat <- ellmer::chat_claude()

  .errorBlock <- nm2rx$nonmemErrorBlock
  .pkBlock    <- nm2rx$nonmemPkBlock
  .predBlock  <- nm2rx$nonmemPredBlock
  .modelText  <- .getCleanModelText(nm2rx)
  .sigmaNames <- nm2rx$sigmaNames

  .attempt     <- 0L
  .validatedUi <- NULL

  validateErrorModel <- ellmer::tool(
    function(modelCode) {
      .attempt <<- .attempt + 1L
      if (.attempt > maxAttempts)
        return(paste0("MAX ATTEMPTS (", maxAttempts, ") REACHED."))

      tryCatch({
        .fn <- eval(parse(text=modelCode), envir=baseenv())
        .ui <- rxode2::as.rxUi(.fn)

        if (is.null(.ui$predDf))
          return(paste0("ATTEMPT ", .attempt, "/", maxAttempts,
                        " FAILED: $predDf is NULL. Add an error line such as ",
                        "`cp ~ add(add.sd)` inside model({})."))

        .rx <- rxode2::rxUiDecompress(.ui)
        .nm <- rxode2::rxUiDecompress(nm2rx)
        .cp <- c("nonmemData", "atol", "rtol", "ssAtol", "ssRtol",
                 "etaData", "ipredData", "predData", "sigmaNames",
                 "dfSub", "thetaMat", "dfObs", "file", "outputExtension")
        lapply(.cp, function(x) {
          if (exists(x, envir=.nm)) assign(x, get(x, envir=.nm), envir=.rx)
        })

        .msg <- try(.nonmem2rxValidate(.rx, msg=NULL, validate=TRUE, ci=0.95, sigdig=3),
                    silent=TRUE)
        if (inherits(.msg, "try-error"))
          return(paste0("ATTEMPT ", .attempt, "/", maxAttempts,
                        " FAILED (solve error): ",
                        conditionMessage(attr(.msg, "condition"))))
        if (is.null(.rx$predAtol)) {
          .cmp  <- .rx$predCompare
          .info <- if (!is.null(.cmp))
            paste0("; max diff=",
                   signif(max(abs(.cmp$nonmem - .cmp$rxode2), na.rm=TRUE), 3))
          else ""
          return(paste0("ATTEMPT ", .attempt, "/", maxAttempts,
                        " FAILED (tolerance): predictions do not match NONMEM",
                        .info, ". Try a different error form."))
        }

        .validatedUi <<- .rx
        paste0("SUCCESS (attempt ", .attempt, "): predAtol=",
               signif(.rx$predAtol, 3))
      }, error=function(e) {
        paste0("ATTEMPT ", .attempt, "/", maxAttempts,
               " ERROR: ", conditionMessage(e))
      })
    },
    name        = "validateErrorModel",
    description = paste0(
      "Validate a proposed nlmixr2 R model function with residual error specification. ",
      "Returns SUCCESS or FAILED with diagnostics."
    ),
    arguments=list(
      modelCode=ellmer::type_string(
        "Complete R function in nlmixr2 style with ini({}) and model({}) blocks, including a residual error line e.g. `cp ~ add(add.sd)`."
      )
    )
  )

  chat$register_tool(validateErrorModel)

  .promptFile <- getOption(
    "nonmem2rx.llmPromptFile",
    system.file("prompts/llmErrorPrompt.txt", package="nonmem2rx")
  )
  .promptTemplate <- paste(readLines(.promptFile, warn=FALSE), collapse="\n")

  .orNA <- function(x) if (!is.null(x) && nzchar(trimws(x))) x else "(not available)"
  .prompt <- .promptTemplate
  .prompt <- gsub("\\{\\{errorBlock\\}\\}",  .orNA(.errorBlock),              .prompt)
  .prompt <- gsub("\\{\\{pkBlock\\}\\}",     .orNA(.pkBlock),                 .prompt)
  .prompt <- gsub("\\{\\{predBlock\\}\\}",   .orNA(.predBlock),               .prompt)
  .prompt <- gsub("\\{\\{sigmaNames\\}\\}",  paste(.sigmaNames, collapse=", "), .prompt)
  .prompt <- gsub("\\{\\{modelText\\}\\}",   .modelText,                      .prompt)
  .prompt <- gsub("\\{\\{maxAttempts\\}\\}", as.character(maxAttempts),        .prompt)

  chat$chat(.prompt)

  if (is.null(.validatedUi)) {
    cli::cli_alert_warning(
      "LLM did not produce a validated error model after {maxAttempts} attempt{?s}"
    )
    return(NULL)
  }
  .validatedUi
}
