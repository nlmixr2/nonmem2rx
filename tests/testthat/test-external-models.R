.nonmem2rx <- function(..., save=FALSE) {
  suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
    skip_on_cran()
  test_that("test nonmemica models", {
    skip_if_not(requireNamespace("nonmemica", quietly = TRUE))
    
    m1 <- .nonmem2rx(system.file("project/model/1001/1001.ctl",package="nonmemica"))
    expect_length(m1$meta$validation, 4L)
    
    m2 <- .nonmem2rx(system.file("project/model/2001/2001.ctl",package="nonmemica"))
    expect_length(m2$meta$validation, 4L)
    
    m3<- .nonmem2rx(system.file("project/model/2002/2002.ctl",package="nonmemica"))
    expect_length(m3$meta$validation, 4L)
    
    m4 <- .nonmem2rx(system.file("project/model/2003/2003.ctl",package="nonmemica"))
    expect_length(m4$meta$validation, 4L)

    m5 <- .nonmem2rx(system.file("project/model/2004/2004.ctl",package="nonmemica"))
    expect_length(m5$meta$validation, 4L)

    m6 <- .nonmem2rx(system.file("project/model/2005/2005.ctl",package="nonmemica"))
    expect_length(m6$meta$validation, 4L)

    m7 <- .nonmem2rx(system.file("project/model/2006/2006.ctl",package="nonmemica"))
    expect_length(m7$meta$validation, 4L)
    
    m8 <- .nonmem2rx(system.file("project/model/2007/2007.ctl",package="nonmemica"))
    expect_length(m8$meta$validation, 4L)
    
  })

  test_that("test nonemem2R models", {
    skip_if_not(requireNamespace("nonmem2R", quietly = TRUE))
    expect_error(.nonmem2rx(system.file("extdata/run001.mod",package="nonmem2R")), NA)
  })

  test_that("test NMdata models", {
    skip_if_not(requireNamespace("NMdata", quietly = TRUE))
    .dat1 <- system.file("examples/data/xgxr1.csv", package="NMdata")
    .dat2 <- system.file("examples/data/xgxr2.csv", package="NMdata")
    .dat4 <- system.file("examples/data/xgxr4.csv", package="NMdata")
    expect_error(.nonmem2rx(system.file("examples/nonmem/xgxr001.mod", package="NMdata")), NA)
    expect_error(.nonmem2rx(system.file("examples/nonmem/xgxr002.mod", package="NMdata")), NA)
    expect_error(.nonmem2rx(system.file("examples/nonmem/xgxr003.mod", package="NMdata")), NA)
    expect_error(.nonmem2rx(system.file("examples/nonmem/xgxr014.mod", package="NMdata")), NA)
    expect_error(.nonmem2rx(system.file("examples/nonmem/xgxr018.mod", package="NMdata")), NA)
    
  })
})
