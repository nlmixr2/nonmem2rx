test_that("test model", {
  
  .m <- function(model, eq="no", reset=TRUE) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_model`, model)
    expect_equal(.nonmem2rx$cmtName, eq)
  }

  x <- c("NPARAMETERS=3\nCOMP=(DEPOT DEFDOSE INITIALOFF) COMP=(CENTRAL DEFOBS NOOFF)\nLINK DEPOT CENTRAL BY 3\nLINK CENTRAL OUTPUT BY 1", "NPARAMETERS=3\nCOMP=(DEPOT DEFDOSE INITIALOFF) COMP=(CENTRAL DEFOBS NOOFF)\nLINK DEPOT CENTRAL BY 3\nLINK CENTRAL OUTPUT BY 1")

  expect_error(nonmem2rxRec.mod(x))

  x <- x[1]

  expect_error(expect_warning(.m(x)))
  
  .m("COMP=(DEPOT DEFDOSE INITIALOFF)", "DEPOT")
  
  .m("COMP=(DEPOT DEFDOSE INITIALOFF) COMP=(CENTRAL DEFOBS NOOFF)",
     c("DEPOT", "CENTRAL"))

  .m("COMP=(DEPOT DEFDOSE INITIALOFF) COMP",
     c("DEPOT", "rxddta2"))

  .m("\nCOMP=(DEPOT DEFDOSE INITIALOFF)\nCOMP=(CENTRAL DEFOBS NOOFF)",
     c("DEPOT", "CENTRAL"))

  expect_warning(.m("NPARAMETERS=3\nCOMP=(DEPOT DEFDOSE INITIALOFF)",
                    "DEPOT"))

  expect_error(.m("malformed"))

  .m("COMP=(DEPOT,INITIALOFF,DEFDOSE) COMP=(CENTRAL,DEFOBS,NOOFF)",
     c("DEPOT", "CENTRAL"))

  .m("COMP=('depot compartment with spaces',INITIALOFF,DEFDOSE) COMP=(CENTRAL,DEFOBS,NOOFF)",
     c("depot compartment with spaces", "CENTRAL"))
  
})
