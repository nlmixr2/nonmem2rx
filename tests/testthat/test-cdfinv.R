test_that("an $ABBR VECTOR record parses", {
  ## `$ABBR VECTOR VQ2(10)` declares the argument vector a `$ABBR FUNCTION`
  ## routine is called with; before this it was a syntax error, so a model
  ## using one could not even be read far enough to say what was wrong
  expect_silent(.Call(`_nonmem2rx_setRecord`, "$ABBR"))
  expect_error(.Call(`_nonmem2rx_trans_abbrec`, " VECTOR VQ2(10)"), NA)
  expect_error(.Call(`_nonmem2rx_trans_abbrec`, " FUNCTION GAMMACDFINV(VQ,10)"), NA)
})

test_that("an inverse-CDF individual parameter is named for what it is", {
  ## A NONMEM model can give an individual parameter a non-normal
  ## distribution by mapping a unit normal ETA through PHI() and then an
  ## inverse CDF (Bauer, NONMEM 7.5.1).  That is the same construction
  ## rxode2 writes as a `dist()` line, and it is not imported yet -- but it
  ## has to say so, rather than surfacing as a syntax error pointing at the
  ## `VQ(1)=` slot assignment the protocol produces.
  .ctl <- paste(c("$PROB gamma",
                  "$ABBR FUNCTION GAMMACDFINV(VQ,10)",
                  "$ABBR VECTOR VQ2(10)",
                  "$PK",
                  "ETARNDCL=PHI(ETA(3))+1.0E-7",
                  "VQ(1)=ETARNDCL",
                  "VQ(2)=ALPHACL",
                  "VQ(3)=BETACL",
                  "VQ(10)=1.0",
                  "CL=GAMMACDFINV(VQ)"), collapse="\n")
  expect_equal(nonmem2rx:::.nonmemCdfInvUsed(.ctl), "GAMMACDFINV")
  expect_error(nonmem2rx:::.nonmemAssertNoCdfInv(.ctl), "GAMMACDFINV")
  expect_error(nonmem2rx:::.nonmemAssertNoCdfInv(.ctl), "inverse CDF")
  ## a user supplied routine is caught by its name, not by the built-in list
  .user <- "$ABBR FUNCTION MYBETACDFINV(VQ,10)\n$PK\nCL=MYBETACDFINV(VQ)"
  expect_equal(nonmem2rx:::.nonmemCdfInvUsed(.user), "MYBETACDFINV")
  ## and an ordinary model is untouched
  expect_equal(nonmem2rx:::.nonmemCdfInvUsed("$PK\nCL=DEXP(THETA(1)+ETA(1))"),
               character(0))
  expect_silent(nonmem2rx:::.nonmemAssertNoCdfInv("$PK\nCL=DEXP(THETA(1))"))
})
