test_that("nmgrd reads the right values", {

  expect_equal(nmgrd(system.file("mods/cpt/runODE032.grd", package="nonmem2rx")),
               c(ITERATION = 25, `GRD(1)` = 560.053, `GRD(2)` = 1694.01, `GRD(3)` = 13.0952,
                 `GRD(4)` = -115, `GRD(5)` = -0.50779, `GRD(6)` = -0.241804, `GRD(7)` = 0.0765655,
                 `GRD(8)` = -0.0282282, `GRD(9)` = -0.117267))

})
