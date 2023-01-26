test_that("test thetas", {
  
  .Call(`_nonmem2rx_trans_theta`, "1 fix")
  .Call(`_nonmem2rx_trans_theta`, "(1 fix)")
  .Call(`_nonmem2rx_trans_theta`, "(1) FIXED")
  .Call(`_nonmem2rx_trans_theta`, "(1, 2.0) FIXED")
  .Call(`_nonmem2rx_trans_theta`, "(1, 2.0 fix)")
  .Call(`_nonmem2rx_trans_theta`, "(1, 2.0)")
  .Call(`_nonmem2rx_trans_theta`, "(1, 2.0, 3.0)")
  .Call(`_nonmem2rx_trans_theta`, "(1, 2.0, 3.0 fix)")
  .Call(`_nonmem2rx_trans_theta`, "(1, 2.0, 3.0) fix")
  .Call(`_nonmem2rx_trans_theta`, "(1,, 3.0)")
})
