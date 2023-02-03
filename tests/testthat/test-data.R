test_that("test data", {

  .f <- function(data, eq="no") {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_data`, data)
    expect_equal(.nonmem2rx$dataFile, eq)
  }
  .f(" matt.csv\n", "matt.csv")
  .f(" 'matt \"s file with spaces.csv'", "matt \"s file with spaces.csv")
  .f(' "matt \'s file with spaces.csv"', "matt 's file with spaces.csv")


  .i <- function(data, eq="no") {
    .clearNonmem2rx()
    nonmem2rxRec.dat(data)
    .ret <- list(data=.nonmem2rx$dataFile,
                 cond=.nonmem2rx$dataCond,
                 ignore1=.nonmem2rx$dataIgnore1,
                 condType=.nonmem2rx$dataCondType)
    ## message(deparse1(.ret))
    expect_equal(.ret, eq)
  }

  .i("PK.csv IGNORE=@ IGNORE=(PKFL.EQ.0)\nIGNORE=(TRTPN.EQ.1) IGNORE=(TRTPN.EQ.3)\nIGNORE=(TRTPN.EQ.4)\n",
     list(data = "PK.csv", cond = c(".data$PKFL == 0", ".data$TRTPN == 1", ".data$TRTPN == 3", ".data$TRTPN == 4"), ignore1="@", condType = "ignore"))

    .i("PK.csv IGNORE=@ IGNORE=(PKFL.EQ.0,TRTPN.EQ.1, TRTPN.EQ.3, TRTPN.EQ.4)\n",
       list(data = "PK.csv", cond = c(".data$PKFL == 0", ".data$TRTPN == 1", ".data$TRTPN == 3", ".data$TRTPN == 4"), ignore1="@", condType = "ignore"))

    .i("PK.csv IGNORE=@ ACCEPT=(PKFL.EQ.0,TRTPN.EQ.1, TRTPN.EQ.3, TRTPN.EQ.4)\n",
       list(data = "PK.csv", cond = c(".data$PKFL == 0", ".data$TRTPN == 1", ".data$TRTPN == 3", ".data$TRTPN == 4"), ignore1="@", condType = "accept"))

    .i(" matt.csv\n",
       list(data = "matt.csv", cond = character(0), ignore1=NULL, condType = "none"))

    .i(" matt.csv IGNORE=m\n",
       list(data = "matt.csv", cond = character(0), ignore1="m", condType = "none"))

    expect_error(nonmem2rxRex.dat(c("a", "b")))


    .f <- function(data, eq="no") {
      .clearNonmem2rx()
      .Call(`_nonmem2rx_trans_data`, data)
      expect_equal(.nonmem2rx$dataRecords, eq)
    }

    .f("matt.csv records=3000", 3000L)


e})
