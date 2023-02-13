test_that("test abbrev  record", {

  .a <- function(abbrev, eq=list(), abbrevLin=0L) {
    .clearNonmem2rx()
    .nonmem2rx$input <- c(OCC="OCC",SID="SID")
    .Call(`_nonmem2rx_trans_abbrec`, abbrev)
    expect_equal(.nonmem2rx$replace, eq)
  }

  expect_error(.a("COMRES=2"), NA)
  expect_error(.a("COMSAV=2"), NA)
  expect_error(.a("DERIV1=NO"), NA)
  expect_error(.a("DERIV2=NO"), NA)
  expect_error(.a("DERIV2=NOCOMMON"), NA)
  expect_error(.a(" FASTDER"), NA)
  expect_error(.a("NOFASTDER"), NA)
  expect_error(.a("DES=FULL"), NA)
  expect_error(.a("DES=COMPACT"), NA)
  expect_error(.a("CHECKMU"), NA)
  expect_error(.a("NOCHECKMU"), NA)
  expect_error(.a("DECLARE A,B(10),C(1,NO-1),INTEGER I J"), NA)
  expect_error(.a("PROTECT"), NA)
  expect_error(.a("FUNCTION BIVARIATE(VBI,5,3)"),NA)
  expect_error(.a("FUNCTION BIVARIATE(*,5)", NA))
  expect_error(.a("FUNCTION FUNCA(VECTRA,25,5)"), NA)

  # now the more interesting examples:

  # direct1
  .a("REPLACE THETA(CL)=THETA(4)",
     list(structure(list("THETA", "CL", 4L), class = "nonmem2rx.rep1")))
  .a("REPLACE ETA(ECL)=ETA(4)",
     list(structure(list("ETA", "ECL", 4L), class = "nonmem2rx.rep1")))
  .a("REPLACE ERR(ECL)=ERR(4)",
     list(structure(list("ERR", "ECL", 4L), class = "nonmem2rx.rep1")))
  .a("REPLACE EPS(ECL)=EPS(4)",
     list(structure(list("EPS", "ECL", 4L), class = "nonmem2rx.rep1")))
  .a("REPLACE DADT(DEPOT)=DADT(1)",
     list(structure(list("DADT", "DEPOT", 1L), class = "nonmem2rx.rep1")))
  .a("REPLACE A(CENTRAL)=A(2)",
     list(structure(list("A", "CENTRAL", 2L), class = "nonmem2rx.rep1")))
  
  expect_error(.a("REPLACE EPS(ECL)=THETA(4)"), "'EPS' to 'THETA'")

  .a("REPLACE PI=3.14159265",
     list(structure(list("PI", "3.14159265"), class = "nonmem2rx.rep2")))
  .a('REPLACE K34="3,4"',
     list(structure(list("K34", "3,4"), class = "nonmem2rx.rep2")))
  .a("REPLACE K34='3,4'",
     list(structure(list("K34", "3,4"), class = "nonmem2rx.rep2")))

  .a("REPLACE THETA(OCC)=THETA(4,7)",
     list(structure(list("THETA", "OCC", c(4, 7)), class = "nonmem2rx.repDI")))

  .a("REPLACE THETA(OCC)=THETA(4 TO 7 BY 2)",
     list(structure(list("THETA", "OCC", c(4, 6)), class = "nonmem2rx.repDI")))
  
})
