.mtimeEv <- function() {
  rxode2::et(amt=100, cmt="depot") |>
    rxode2::et(c(0.5, 1, 1.5, 2, 3, 4, 6, 8))
}

test_that("delay() models keep the continuous time (#267)", {
  skip_on_cran()
  .dde <- rxode2::rxode2({
    cdel <- delay(central, 4)
    d/dt(central) <- -0.1 * central
    d/dt(resp) <- 10 * (1 - cdel / (1 + cdel)) - 0.5 * resp
    resp(0) <- 20
    past(central, 4) <- 0
  })
  expect_false(.nonmem2rxUseNonmemSolve(.dde))
  .ode <- rxode2::rxode2({
    cl <- 3 * (1 + 0.05 * time)
    d/dt(central) <- -cl / 30 * central
  })
  expect_equal(.nonmem2rxUseNonmemSolve(.ode), .nonmem2rxHasNonmemSolve())
  # the delay is the integration time, so resp stays at kin/kout until t=4
  .ev <- rxode2::et(amt=100, cmt="central") |> rxode2::et(c(1, 3, 5))
  .s <- suppressWarnings(.nonmem2rxSolve(.dde, .ev, returnType="data.frame"))
  expect_equal(.s$resp[1:2], c(20, 20))
})

test_that("MPAST(1) switches after the MTIME(1) interval like NONMEM (#267)", {
  skip_on_cran()
  skip_if_not(.nonmem2rxHasNonmemSolve(), "rxode2 without rxSolve(nonmem=TRUE)")
  # the statements nonmem2rx writes for MTIME(1)/MPAST(1) in $PK
  .pk <- rxode2::rxode2({
    rx.mtime.1. <- 1.5
    mtime(rx.mtime.1.) <- rx.mtime.1.
    rx.mpast.1. <- ifelse(time > rx.mtime.1., 1, 0)
    ka <- 2 * (1 - rx.mpast.1.) + 0.2 * rx.mpast.1.
    d/dt(depot) <- -ka * depot
    d/dt(central) <- ka * depot - 0.1 * central
  })
  # NONMEM: KA is 2 up to MTIME(1) and 0.2 afterwards
  .des <- rxode2::rxode2({
    d/dt(depot) <- -ifelse(t > 1.5, 0.2, 2) * depot
    d/dt(central) <- ifelse(t > 1.5, 0.2, 2) * depot - 0.1 * central
  })
  .s1 <- .nonmem2rxSolve(.pk, .mtimeEv(), returnType="data.frame",
                         atol=1e-10, rtol=1e-10)
  .s2 <- rxode2::rxSolve(.des, .mtimeEv(), returnType="data.frame",
                         atol=1e-10, rtol=1e-10)
  # the mtime() adds an output row at 1.5; with time >= MTIME(1) the
  # switch would come one interval early (78.3 instead of 85.4 at 1.5)
  expect_equal(.s1$central[match(.s2$time, .s1$time)], .s2$central,
               tolerance=1e-6)
})
