test_that("test error", {
  expect_true(.isParamWeps(quote(y<-ipred+w*eps1)))
  expect_true(.isParamWeps(quote(y<-ipred+eps1*w)))
  expect_true(.isParamWeps(quote(y<-f+w*eps1)))
  expect_true(.isParamWeps(quote(y<-f+eps1*w)))
  expect_true(.isParamWeps(quote(y<-w*eps1+ipred)))
  expect_true(.isParamWeps(quote(y<-eps1*w+ipred)))
  expect_true(.isParamWeps(quote(y<-w*eps1+f)))
  expect_true(.isParamWeps(quote(y<-eps1*w+f)))
  expect_false(.isParamWeps(quote(y<-eps1*w^2+f)))

  expect_true(.isAddW(quote(w <- theta1)))
  expect_equal(.nonmem2rx$addPar, "theta1")
  
})
