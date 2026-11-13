test_that("test model", {
  .m <- function(model, eq = "no", reset = TRUE) {
    .Call(`_nonmem2rx_setRecord`, "$MODEL")
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_model`, model)
    expect_equal(.nonmem2rx$cmtName, eq)
  }

  x <- c(
    "NPARAMETERS=3\nCOMP=(DEPOT DEFDOSE INITIALOFF) COMP=(CENTRAL DEFOBS NOOFF)\nLINK DEPOT CENTRAL BY 3\nLINK CENTRAL OUTPUT BY 1",
    "NPARAMETERS=3\nCOMP=(DEPOT DEFDOSE INITIALOFF) COMP=(CENTRAL DEFOBS NOOFF)\nLINK DEPOT CENTRAL BY 3\nLINK CENTRAL OUTPUT BY 1"
  )

  expect_error(nonmem2rxRec.mod(x))

  x <- x[1]

  expect_error(expect_warning(.m(x)))

  .m("COMP=(DEPOT DEFDOSE INITIALOFF)", "DEPOT")

  .m(
    "COMP=(DEPOT DEFDOSE INITIALOFF) COMP=(CENTRAL DEFOBS NOOFF)",
    c("DEPOT", "CENTRAL")
  )

  .m("COMP=(DEPOT DEFDOSE INITIALOFF) COMP", c("DEPOT", "rxddta2"))

  .m(
    "\nCOMP=(DEPOT DEFDOSE INITIALOFF)\nCOMP=(CENTRAL DEFOBS NOOFF)",
    c("DEPOT", "CENTRAL")
  )

  expect_warning(.m("NPARAMETERS=3\nCOMP=(DEPOT DEFDOSE INITIALOFF)", "DEPOT"))

  expect_error(.m("malformed"))

  .m(
    "COMP=(DEPOT,INITIALOFF,DEFDOSE) COMP=(CENTRAL,DEFOBS,NOOFF)",
    c("DEPOT", "CENTRAL")
  )

  .m(
    "COMP=('depot compartment with spaces',INITIALOFF,DEFDOSE) COMP=(CENTRAL,DEFOBS,NOOFF)",
    c("depot compartment with spaces", "CENTRAL")
  )

  .m("COMP=(26XYL)", "rxddta26XYL")
  .m("COMP=26XYL", "rxddta26XYL")
})

test_that("DEFOBS/DEFDOSE in $MODEL set the default compartments (#289)", {
  .cmt <- function(model) {
    .Call(`_nonmem2rx_setRecord`, "$MODEL")
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_model`, model)
    c(dose = .nonmem2rx$defdose, obs = .nonmem2rx$defobs)
  }
  expect_equal(
    .cmt("COMP=(DEPOT, DEFDOSE) COMP=(CENT, DEFOBS)"),
    c(dose = 1L, obs = 2L)
  )
  expect_equal(
    .cmt("COMP=(CENT, DEFOBS) COMP=(DEPOT, DEFDOSE)"),
    c(dose = 2L, obs = 1L)
  )
  expect_equal(
    .cmt("COMP=(DEPOT) COMP=(CENT DEFOBSERVATION)"),
    c(dose = 1L, obs = 2L)
  )
  # DEFOBS takes precedence over a compartment named central
  expect_equal(
    .cmt("COMP=(DEPOT) COMP=(CENTRAL) COMP=(PERI DEFOBS)"),
    c(dose = 1L, obs = 3L)
  )
  # without DEFOBS, central is still the fallback
  expect_equal(.cmt("COMP=(DEPOT) COMP=(CENTRAL)"), c(dose = 1L, obs = 2L))
})

test_that("DEFOBS chooses the observed compartment for F (#289)", {
  .ctl <- function(model) {
    c(
      "$PROBLEM d",
      "$INPUT ID TIME EVID AMT CMT DV",
      "$DATA d.csv IGNORE=@",
      "$SUBROUTINES ADVAN13 TOL=9",
      model,
      "$PK",
      "KA = THETA(1)",
      "CL = THETA(2)",
      "V = THETA(3)",
      "S2 = V",
      "$DES",
      "DADT(1) = -KA * A(1)",
      "DADT(2) = KA * A(1) - CL / V * A(2)",
      "$ERROR",
      "Y = F * (1 + EPS(1))",
      "$THETA (0, 1) (0, 4) (0, 50)",
      "$SIGMA 0.04"
    )
  }
  .f <- function(model) {
    .file <- withr::local_tempfile(fileext = ".ctl")
    writeLines(.ctl(model), .file)
    withr::with_options(
      list(
        nonmem2rx.save = FALSE,
        nonmem2rx.load = FALSE,
        nonmem2rx.overwrite = FALSE
      ),
      {
        .ui <- suppressMessages(suppressWarnings(
          nonmem2rx(.file, validate = FALSE)
        ))
      }
    )
    grep("^ *f <-", deparse(.ui$fun), value = TRUE)
  }
  expect_match(
    .f("$MODEL COMP=(DEPOT, DEFDOSE) COMP=(CENT, DEFOBS)"),
    "f <- CENT/scale2",
    fixed = TRUE
  )
  expect_match(
    .f("$MODEL COMP=(DEPOT) COMP=(CENTRAL)"),
    "f <- CENTRAL/scale2",
    fixed = TRUE
  )
})
