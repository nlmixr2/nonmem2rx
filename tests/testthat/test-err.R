test_that("test error parsing", {
  
  expect_true(.isParamWeps(quote(y<-ipred+w*eps1)))
  expect_false(.isParamWeps(quote(y<-ipred+w/eps1)))
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
  
  expect_false(.isAddW(quote(w <- f*theta1)))
  expect_false(.isAddW(quote(w <- dg1)))
  
  expect_true(.isThetaF(quote(theta1*f)))
  expect_equal(.nonmem2rx$propPar, "theta1")
  expect_equal(.nonmem2rx$curF, "f")
  expect_true(.isThetaF(quote(ipred*theta1)))
  expect_equal(.nonmem2rx$propPar, "theta1")
  expect_equal(.nonmem2rx$curF, "ipred")
  expect_false(.isThetaF(quote(ipred/theta1)))
  expect_true(.isPropW(quote(w <-theta1*f)))

  expect_true(.isAddPropW1(quote(w <- theta1*f+theta2)))
  expect_equal(.nonmem2rx$propPar, "theta1")
  expect_equal(.nonmem2rx$addPar, "theta2")
  expect_equal(.nonmem2rx$curF, "f")
  expect_false(.isAddPropW1(quote(w <- theta1*f^2+theta2)))

  expect_true(.isTheta2(quote(theta1*theta1)))
  expect_false(.isTheta2(quote(theta1*theta2)))

  expect_true(.isTheta2(quote(theta1^2)))
  expect_true(.isTheta2(quote(theta1**2.)))

  expect_true(.isTheta2(quote(ipred*ipred), useF=TRUE))
  expect_true(.isTheta2(quote(f*ipred), useF=TRUE))
  expect_true(.isTheta2(quote(f*f), useF=TRUE))
  expect_true(.isTheta2(quote(f^2), useF=TRUE))

  expect_true(.isTheta2F2(quote(f*f*theta1*theta1)))
  expect_true(.isTheta2F2(quote(f*theta1*f*theta1)))
  expect_true(.isTheta2F2(quote(f*theta1*theta1*f)))
  expect_true(.isTheta2F2(quote(theta1*f*theta1*f)))
  expect_true(.isTheta2F2(quote(theta1*theta1*f*f)))
  expect_true(.isTheta2F2(quote(theta1^2*f*f)))
  expect_true(.isTheta2F2(quote(f*theta1^2*f)))
  expect_true(.isTheta2F2(quote(f*f*theta1^2)))
  expect_true(.isTheta2F2(quote(f^2*theta1^2)))
  expect_true(.isTheta2F2(quote(theta1^2*f^2)))
  expect_false(.isTheta2F2(quote(f*f*f*theta1)))
  expect_equal(.nonmem2rx$propPar, "theta1")

  expect_true(.isAddPropW2(quote(W<-sqrt(theta1^2+theta2^2*f^2))))
  expect_equal(.nonmem2rx$propPar, "theta2")
  expect_equal(.nonmem2rx$addPar, "theta1")
  expect_equal(.nonmem2rx$curF, "f")

  expect_true(.isAddPropW2(quote(W<-sqrt(theta1^2+theta2^2*ipred^2))))
  expect_equal(.nonmem2rx$propPar, "theta2")
  expect_equal(.nonmem2rx$addPar, "theta1")
  expect_equal(.nonmem2rx$curF, "ipred")

  expect_true(.isAddPropW2(quote(W<-sqrt(theta1^2+theta2*theta2*ipred^2))))
  expect_equal(.nonmem2rx$propPar, "theta2")
  expect_equal(.nonmem2rx$addPar, "theta1")
  expect_equal(.nonmem2rx$curF, "ipred")
})

test_that("test rxode2 function to model function", {
  f <- function() {
    ini({
      theta1 <- c(0, 25.7435)
      label("TVCL")
      theta2 <- c(0, 1.36688)
      label("TVV")
      theta3 <- c(0, 7.25257)
      label("TVKA")
      theta4 <- c(0, 0.215994)
      label("LAG")
      theta5 <- c(0, 0.215055)
      label("Prop.Err")
      theta6 <- c(0, 0.0096742)
      label("Add.Err")
      theta7 <- c(0, 0.00637473, 0.02941)
      label("CRCL onCL")
      eta1 ~ 0.0728446
      eta2 ~ 0.0419272
      eta3 ~ 2.33689
    })
    model({
      tvcl <- theta1 * (1 + theta7 * (CLCR - 65))
      tvv <- theta2 * WT
      cl <- tvcl * exp(eta1)
      v <- tvv * exp(eta2)
      ka <- theta3 * exp(eta3)
      alag(depot) <- theta4
      k <- cl/v
      rxlincmt1 = linCmt()
      f <- rxlincmt1
      a1 <- dose(depot) * exp(-ka * tad(depot))
      a2 <- rxlincmt1
      ipred <- a2/v
      ires <- ipred - DV
      w <- sqrt(theta5^2 * ipred^2 + theta6^2)
      iwres <- ires/w
      y <- ipred + w * eps1
    })
  }

  f <- f()
  f <- .determineError(f)

  expect_equal(paste(f$predDf$errType), "add + prop")
  expect_equal(paste(f$predDf$addProp), "combined2")

  f <- function() {
    ini({
      theta1 <- c(0, 25.7435)
      label("TVCL")
      theta2 <- c(0, 1.36688)
      label("TVV")
      theta3 <- c(0, 7.25257)
      label("TVKA")
      theta4 <- c(0, 0.215994)
      label("LAG")
      theta5 <- c(0, 0.215055)
      label("Prop.Err")
      theta6 <- c(0, 0.0096742)
      label("Add.Err")
      theta7 <- c(0, 0.00637473, 0.02941)
      label("CRCL onCL")
      eta1 ~ 0.0728446
      eta2 ~ 0.0419272
      eta3 ~ 2.33689
    })
    model({
      tvcl <- theta1 * (1 + theta7 * (CLCR - 65))
      tvv <- theta2 * WT
      cl <- tvcl * exp(eta1)
      v <- tvv * exp(eta2)
      ka <- theta3 * exp(eta3)
      alag(depot) <- theta4
      k <- cl/v
      rxlincmt1 = linCmt()
      f <- rxlincmt1
      a1 <- dose(depot) * exp(-ka * tad(depot))
      a2 <- rxlincmt1
      ipred <- a2/v
      ires <- ipred - DV
      w <- theta5 * ipred + theta6
      iwres <- ires/w
      y <- ipred + w * eps1
    })
  }

  f <- f()
  f <- .determineError(f)

  expect_equal(paste(f$predDf$errType), "add + prop")
  expect_equal(paste(f$predDf$addProp), "combined1")


  f <- function() {
    ini({
      theta1 <- c(0, 25.7435)
      label("TVCL")
      theta2 <- c(0, 1.36688)
      label("TVV")
      theta3 <- c(0, 7.25257)
      label("TVKA")
      theta4 <- c(0, 0.215994)
      label("LAG")
      theta5 <- c(0, 0.215055)
      label("Prop.Err")
      theta7 <- c(0, 0.00637473, 0.02941)
      label("CRCL onCL")
      eta1 ~ 0.0728446
      eta2 ~ 0.0419272
      eta3 ~ 2.33689
    })
    model({
      tvcl <- theta1 * (1 + theta7 * (CLCR - 65))
      tvv <- theta2 * WT
      cl <- tvcl * exp(eta1)
      v <- tvv * exp(eta2)
      ka <- theta3 * exp(eta3)
      alag(depot) <- theta4
      k <- cl/v
      rxlincmt1 = linCmt()
      f <- rxlincmt1
      a1 <- dose(depot) * exp(-ka * tad(depot))
      a2 <- rxlincmt1
      ipred <- a2/v
      ires <- ipred - DV
      w <- theta5 * ipred
      iwres <- ires/w
      y <- ipred + w * eps1
    })
  }
  f <- f()
  f <- .determineError(f)
  expect_equal(paste(f$predDf$errType), "prop")
  f <- function() {
    ini({
      theta1 <- c(0, 25.7435)
      label("TVCL")
      theta2 <- c(0, 1.36688)
      label("TVV")
      theta3 <- c(0, 7.25257)
      label("TVKA")
      theta4 <- c(0, 0.215994)
      label("LAG")
      theta5 <- c(0, 0.215055)
      label("Prop.Err")
      theta7 <- c(0, 0.00637473, 0.02941)
      label("CRCL onCL")
      eta1 ~ 0.0728446
      eta2 ~ 0.0419272
      eta3 ~ 2.33689
    })
    model({
      tvcl <- theta1 * (1 + theta7 * (CLCR - 65))
      tvv <- theta2 * WT
      cl <- tvcl * exp(eta1)
      v <- tvv * exp(eta2)
      ka <- theta3 * exp(eta3)
      alag(depot) <- theta4
      k <- cl/v
      rxlincmt1 = linCmt()
      f <- rxlincmt1
      a1 <- dose(depot) * exp(-ka * tad(depot))
      a2 <- rxlincmt1
      ipred <- a2/v
      ires <- ipred - DV
      w <- theta5 
      iwres <- ires/w
      y <- ipred + w * eps1
    })
  }
  f <- f()
  f <- .determineError(f)
  expect_equal(paste(f$predDf$errType), "add")
})
