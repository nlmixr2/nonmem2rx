## nocov start
### Parser build
.nonmem2rxBuildOmega <- function() {
  message("Update Parser c for omega block")
  dparser::mkdparse(devtools::package_file("inst/omega.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxOmega")
  file.rename(devtools::package_file("src/omega.g.d_parser.c"),
              devtools::package_file("src/omega.g.d_parser.h"))
}



.nonmem2rxBuildTheta <- function() {
  message("Update Parser c for theta block")
  dparser::mkdparse(devtools::package_file("inst/theta.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxTheta")
  file.rename(devtools::package_file("src/theta.g.d_parser.c"),
              devtools::package_file("src/theta.g.d_parser.h"))
}

.nonmem2rxBuildModel <- function() {
  message("Update Parser c for model block")
  dparser::mkdparse(devtools::package_file("inst/model.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxModel")
  file.rename(devtools::package_file("src/model.g.d_parser.c"),
              devtools::package_file("src/model.g.d_parser.h"))
}

.nonmem2rxBuildInput <- function() {
  message("Update Parser c for input block")
  dparser::mkdparse(devtools::package_file("inst/input.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxInput")
  file.rename(devtools::package_file("src/input.g.d_parser.c"),
              devtools::package_file("src/input.g.d_parser.h"))
}

.nonmem2rxBuildAbbrev <- function() {
  message("Update Parser c for abbrev block")
  dparser::mkdparse(devtools::package_file("inst/abbrev.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxAbbrev")
  file.rename(devtools::package_file("src/abbrev.g.d_parser.c"),
              devtools::package_file("src/abbrev.g.d_parser.h"))
}

.nonmem2rxBuildSub <- function() {
  message("Update Parser c for sub block")
  dparser::mkdparse(devtools::package_file("inst/sub.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxSub")
  file.rename(devtools::package_file("src/sub.g.d_parser.c"),
              devtools::package_file("src/sub.g.d_parser.h"))
}

.nonmem2rxBuildLst <- function() {
  message("Update Parser c for lst final estimate parsing")
  dparser::mkdparse(devtools::package_file("inst/lst.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxLst")
  file.rename(devtools::package_file("src/lst.g.d_parser.c"),
              devtools::package_file("src/lst.g.d_parser.h"))
}

.nonmem2rxBuildData <- function() {
  message("Update Parser c for data block")
  dparser::mkdparse(devtools::package_file("inst/data.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxData")
  file.rename(devtools::package_file("src/data.g.d_parser.c"),
              devtools::package_file("src/data.g.d_parser.h"))
}

.nonmem2rxBuildTab <- function() {
  message("Update Parser c for tab block")
  dparser::mkdparse(devtools::package_file("inst/tab.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxTab")
  file.rename(devtools::package_file("src/tab.g.d_parser.c"),
              devtools::package_file("src/tab.g.d_parser.h"))
}


.nonmem2rxBuildGram <- function() {
  .nonmem2rxBuildTheta()
  .nonmem2rxBuildOmega()
  .nonmem2rxBuildModel()
  .nonmem2rxBuildInput()
  .nonmem2rxBuildAbbrev()
  .nonmem2rxBuildSub()
  .nonmem2rxBuildLst()
  .nonmem2rxBuildData()
  .nonmem2rxBuildTab()
  invisible("")
}
## nocov end
