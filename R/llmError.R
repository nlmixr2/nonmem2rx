#' Registry of ellmer chat engines usable for LLM-assisted error detection
#'
#' Each entry maps a short provider name to the exported `ellmer::chat_*`
#' function that creates it and the API-key environment variable(s) that
#' indicate the provider is configured.  The order of the list defines the
#' auto-detection priority when no engine is explicitly requested.
#'
#' Providers that do not rely on an API key (e.g. `ollama`, `lmstudio`,
#' `vllm`) are intentionally omitted from auto-detection but remain reachable
#' by name through `getOption("nonmem2rx.llmProvider")` -- any exported
#' `ellmer::chat_*` engine can be selected that way.
#'
#' @return named list; each element has `fun` (ellmer chat function name) and
#'   `env` (character vector of API-key environment variables)
#' @noRd
#' @author Matthew L. Fidler
.llmChatEngines <- function() {
  list(
    anthropic     = list(fun="chat_anthropic",    env="ANTHROPIC_API_KEY"),
    openai        = list(fun="chat_openai",        env="OPENAI_API_KEY"),
    google_gemini = list(fun="chat_google_gemini", env=c("GEMINI_API_KEY", "GOOGLE_API_KEY")),
    mistral       = list(fun="chat_mistral",       env="MISTRAL_API_KEY"),
    groq          = list(fun="chat_groq",          env="GROQ_API_KEY"),
    deepseek      = list(fun="chat_deepseek",      env="DEEPSEEK_API_KEY"),
    openrouter    = list(fun="chat_openrouter",    env="OPENROUTER_API_KEY"),
    perplexity    = list(fun="chat_perplexity",    env="PERPLEXITY_API_KEY"),
    huggingface   = list(fun="chat_huggingface",   env="HUGGINGFACE_API_KEY"),
    cloudflare    = list(fun="chat_cloudflare",    env="CLOUDFLARE_API_KEY"),
    azure_openai  = list(fun="chat_azure_openai",  env="AZURE_OPENAI_API_KEY"),
    databricks    = list(fun="chat_databricks",    env="DATABRICKS_TOKEN"),
    snowflake     = list(fun="chat_snowflake",     env=c("SNOWFLAKE_TOKEN", "SNOWFLAKE_PRIVATE_KEY"))
  )
}

#' Resolve an ellmer chat engine by name
#'
#' Accepts any exported `ellmer::chat_*` engine, given either as the bare
#' provider name (`"openai"`) or the full function name (`"chat_openai"`).
#'
#' @param provider length-one character naming an ellmer chat engine
#' @return the exported `ellmer::chat_*` function
#' @noRd
#' @author Matthew L. Fidler
.llmResolveChatFun <- function(provider) {
  .fnName <- if (startsWith(provider, "chat_")) provider else paste0("chat_", provider)
  .exported <- grep("^chat_", getNamespaceExports("ellmer"), value=TRUE)
  if (!.fnName %in% .exported) {
    stop("unknown ellmer chat engine: '", provider, "'\n",
         "available engines: ",
         paste(sort(sub("^chat_", "", .exported)), collapse=", "),
         call.=FALSE)
  }
  getExportedValue("ellmer", .fnName)
}

#' Create the default ellmer chat engine for LLM-assisted error detection
#'
#' Resolution order:
#'
#' 1. `getOption("nonmem2rx.llmProvider")` -- may be an ellmer chat function,
#'    a provider name (`"openai"`), or a full function name (`"chat_openai"`);
#'    this exposes every engine exported by ellmer.
#' 2. auto-detection: the first engine in [.llmChatEngines()] whose API-key
#'    environment variable is set.
#'
#' @return an ellmer chat object
#' @noRd
#' @author Matthew L. Fidler
.llmDefaultChat <- function() {
  .provider <- getOption("nonmem2rx.llmProvider", NULL)
  if (!is.null(.provider)) {
    if (is.function(.provider)) return(.provider())
    .minfo(paste0("using LLM engine from getOption('nonmem2rx.llmProvider'): ", .provider))
    return(.llmResolveChatFun(.provider)())
  }
  .engines <- .llmChatEngines()
  for (.nm in names(.engines)) {
    .e <- .engines[[.nm]]
    if (any(nzchar(Sys.getenv(.e$env)))) {
      .minfo(paste0("auto-detected LLM engine ellmer::", .e$fun,
                    "() from environment variable ",
                    paste(.e$env[nzchar(Sys.getenv(.e$env))], collapse="/")))
      return(.llmResolveChatFun(.e$fun)())
    }
  }
  stop("no LLM API key detected for any ellmer chat engine\n",
       "set an API key (e.g. ANTHROPIC_API_KEY, OPENAI_API_KEY, GEMINI_API_KEY), ",
       "pass an ellmer chat object via the `chat` argument, or select a provider ",
       "with options(nonmem2rx.llmProvider='openai')",
       call.=FALSE)
}

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
#' @param chat ellmer chat object; if NULL a default engine is selected by
#'   [.llmDefaultChat()] (honoring `getOption("nonmem2rx.llmProvider")` and
#'   auto-detecting from available API keys)
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

  if (is.null(chat)) chat <- .llmDefaultChat()

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
