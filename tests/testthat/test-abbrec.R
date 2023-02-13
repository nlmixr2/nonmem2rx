test_that("test abbrev  record", {

  .a <- function(abbrev, eq=NULL, abbrevLin=0L) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_abbrec`, abbrev)
    expect_equal(NULL, eq)
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
  

})
