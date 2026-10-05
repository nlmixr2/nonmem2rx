## Summaries of a kit run.

kitReport <- function(res, outDir) {
  utils::write.csv(res, file.path(outDir, "summary.csv"), row.names=FALSE)
  .fmt <- function(x) ifelse(is.na(x), "", formatC(x, digits=3, format="g"))
  .cols <- intersect(c("case", "status", "tags", "dryMaxRel", "dryOmegaDiff",
                       "drySigmaDiff", "ipredRtol",
                       "predRtol", "iwresAtol", "nmSeconds", "note"),
                     names(res))
  .tab <- res[, .cols, drop=FALSE]
  for (.n in intersect(c("dryMaxRel", "dryOmegaDiff", "drySigmaDiff",
                         "ipredRtol", "predRtol", "iwresAtol",
                         "nmSeconds"), .cols)) {
    .tab[[.n]] <- .fmt(.tab[[.n]])
  }
  .tab$note <- ifelse(is.na(.tab$note), "",
                      gsub("[|\n]", " ", substr(.tab$note, 1, 160)))
  .counts <- table(factor(res$status,
                          levels=c("PASS", "FAIL", "ERROR", "XFAIL", "XPASS")))
  .md <- c("# nonmem2rx kit results", "",
           paste0("Run: ", format(Sys.time()), "; mode: ",
                  paste(unique(res$mode), collapse=", "),
                  "; nonmem2rx ", as.character(utils::packageVersion("nonmem2rx")),
                  "; rxode2 ", as.character(utils::packageVersion("rxode2"))),
           "",
           paste(paste0(names(.counts), ": ", .counts), collapse=" | "), "",
           "Columns: `dryMaxRel` = max % difference between the translated",
           "model's PRED and the rxode2 simulation model (NONMEM-free);",
           "`dryOmegaDiff`/`drySigmaDiff` = max relative difference of the",
           "imported omega/sigma matrices from the truth;",
           "`ipredRtol`/`predRtol` = median % difference rxode2 vs NONMEM",
           "(from nonmem2rx validation).", "",
           paste0("| ", paste(.cols, collapse=" | "), " |"),
           paste0("|", paste(rep("---", length(.cols)), collapse="|"), "|"),
           apply(.tab, 1, function(r) paste0("| ", paste(r, collapse=" | "), " |")))
  writeLines(.md, file.path(outDir, "summary.md"))
  invisible(.counts)
}
