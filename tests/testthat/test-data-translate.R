test_that("$DATA options parse (#181)", {
  .p <- function(data) {
    .Call(`_nonmem2rx_setRecord`, "$DATA")
    .clearNonmem2rx()
    nonmem2rxRec.dat(data)
  }

  .p("../../DATASETS/DERIVED/.. IGNORE=@ TRANSLATE = (TIME/24)")
  expect_equal(.nonmem2rx$dataFile, "../../DATASETS/DERIVED/..")
  expect_equal(.nonmem2rx$dataIgnore1, "@")
  expect_equal(.nonmem2rx$dataTranslate, list(TIME=list(factor=24, digits=2L)))

  .p("file.csv translate=(TIME/1.0000, II/0.01/6)")
  expect_equal(.nonmem2rx$dataTranslate,
               list(TIME=list(factor=1, digits=4L),
                    II=list(factor=0.01, digits=6L)))

  .p("file.csv Translate=(TAFD/1/4 II/24.0/0)")
  expect_equal(.nonmem2rx$dataTranslate,
               list(TAFD=list(factor=1, digits=4L),
                    II=list(factor=24, digits=2L)))

  .p("file.csv (3F10.0,2(1X,F5.0)) RECORDS=ID NULL='0' LAST20=-1 MISDAT=1.0E-99 MISDAT=-99 REPL=3 NOOPEN CHECKDATA BLANKOK NOFDATACSV PRED_IGNORE_DATA LRECL=80 REWIND WIDE")
  expect_equal(.nonmem2rx$dataRecordsLabel, "ID")
  expect_equal(.nonmem2rx$dataNull, "0")
  expect_equal(.nonmem2rx$dataLast20, -1L)
  expect_equal(.nonmem2rx$dataMisdat, c(1e-99, -99))
  expect_equal(.nonmem2rx$dataRepl, 3L)

  .p("file.csv ignore=# ignore=(GEN.EQ.M, OCC==1.0000E+00, A/=2, B.eqn.3) nrecs=20")
  expect_equal(.nonmem2rx$dataCond,
               c(".data$GEN == 'M'", ".data$OCC == 1.0000E+00", ".data$A != 2",
                 "as.numeric(.data$B) == 3"))
  expect_equal(.nonmem2rx$dataIgnore1, "#")
  expect_equal(.nonmem2rx$dataRecords, 20L)

  # backslashes in unquoted values are escaped for R
  .p("file.csv IGNORE=(GEN.EQ.M\\F)")
  expect_equal(.nonmem2rx$dataCond, ".data$GEN == 'M\\\\F'")
  expect_equal(eval(parse(text=.nonmem2rx$dataCond),
                    list(.data=list(GEN="M\\F"))), TRUE)

  .p("file.csv ACCEPT=(SEX='F' AGE.LE.60)")
  expect_equal(.nonmem2rx$dataCond, c(".data$SEX == 'F'", ".data$AGE <= 60"))
  expect_equal(.nonmem2rx$dataCondType, "accept")

  .p("*")
  expect_equal(.nonmem2rx$dataFile, "*")

  # a format specification may span lines
  .p("file.csv (3F10.0,\n  2F5.0) IGNORE=@")
  expect_equal(.nonmem2rx$dataIgnore1, "@")

  # the "=" is optional
  .p("file.csv RECORDS ID LAST20 30 MISDAT 3 REPL 2 NULL 0")
  expect_equal(.nonmem2rx$dataRecordsLabel, "ID")
  expect_equal(.nonmem2rx$dataLast20, 30L)
  expect_equal(.nonmem2rx$dataMisdat, 3)
  expect_equal(.nonmem2rx$dataRepl, 2L)
  expect_equal(.nonmem2rx$dataNull, "0")
  .p("file.csv RECORDS 20 TRANSLATE (TIME/24)")
  expect_equal(.nonmem2rx$dataRecords, 20L)
  expect_equal(.nonmem2rx$dataTranslate, list(TIME=list(factor=24, digits=2L)))
})

test_that("$DATA contiguous runs (#181)", {
  expect_equal(.dataRuns(c(1, 1, 2, 2, 1)), c(1, 1, 2, 2, 3))
  expect_equal(.dataRuns(c(NA, NA, 2)), c(1, 1, 2))
  expect_equal(.dataRuns(character(0)), integer(0))
})

test_that("$DATA malformed dates are missing (#181)", {
  expect_equal(.dataDateDays(c("12/31/1999/1", "3"), "DATE"), c(NA, 3))
})

test_that("$DATA DAT2/DAT3 field order (#181)", {
  .ref <- as.numeric(as.Date("1999-12-31"))
  expect_equal(.dataDateDays("1999-12-31", "DAT2"), .ref)
  expect_equal(.dataDateDays("1999-31-12", "DAT3"), .ref)
  expect_equal(.dataDateDays("31-12-1999", "DAT1"), .ref)
  expect_equal(.dataDateDays("12/31/1999", "DATE"), .ref)
  # two fields: month/day in the label's order
  .md <- as.numeric(as.Date("2000-12-31"))
  expect_equal(.dataDateDays("12-31", "DAT2"), .md)
  expect_equal(.dataDateDays("31-12", "DAT3"), .md)
  expect_equal(.dataDateDays("31-12", "DAT1"), .md)
  expect_equal(.dataDateDays("12-31", "DATE"), .md)
})

test_that("$DATA TRANSLATE digits (#181)", {
  expect_equal(.dataTranslateDigits("24", ""), 2L)
  expect_equal(.dataTranslateDigits("1.0000", ""), 4L)
  expect_equal(.dataTranslateDigits("1", "4"), 4L)
  expect_equal(.dataTranslateDigits("0.01", "6"), 6L)
  expect_equal(.dataTranslateDigits("24", "0"), 2L)
  expect_equal(.dataTranslateDigits("24", "3.7"), 3L)
  expect_equal(.dataTranslateDigits("24", "20"), 12L)
})

test_that("$DATA options are applied when importing data (#181)", {
  .read <- function(input, data, csv) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_setRecord`, "$INPUT")
    .Call(`_nonmem2rx_trans_input`, input)
    .Call(`_nonmem2rx_setRecord`, "$DATA")
    nonmem2rxRec.dat(paste("data.csv", data))
    withr::with_tempdir({
      writeLines(csv, "data.csv")
      writeLines("", "run.ctl")
      suppressMessages(.readInDataFromNonmem("run.ctl", inputData=NULL))
    })
  }
  .csv <- c("ID,TIME,AMT,II,DV,GEN",
            "1,0,100,12,.,M",
            "1,12,0,0,5,M",
            "1,30,0,0,4,M",
            "2,0,100,12,.,F",
            "2,6,0,0,3,F",
            "3,0,100,12,.,F")

  # TIME/24 converts hours to days with 2 digits; II/0.01/6
  .d <- .read("ID TIME AMT II DV GEN=DROP",
              "IGNORE=@ IGNORE=(GEN.EQ.M) TRANSLATE=(TIME/24, II/0.01/6)", .csv)
  expect_equal(.d$ID, c(2, 2, 3))
  expect_equal(.d$TIME, c(0, 0.25, 0))
  expect_equal(.d$II, c(1200, 0, 1200))
  # the DROP item can be used in IGNORE and is then dropped
  expect_false("GEN" %in% names(.d))

  # rounding to the requested digits
  .d <- .read("ID TIME AMT II DV GEN", "IGNORE=@ TRANSLATE=(TIME/24)", .csv)
  expect_equal(.d$TIME, c(0, 0.5, 1.25, 0, 0.25, 0))
  .d <- .read("ID TIME AMT II DV GEN", "IGNORE=@ TRANSLATE=(TIME/7/3)", .csv)
  expect_equal(.d$TIME, round(c(0, 12, 30, 0, 6, 0) / 7, 3))

  # TRANSLATE through a $INPUT synonym (either side)
  .d <- .read("ID TAFD=TIME AMT II DV GEN", "IGNORE=@ TRANSLATE=(TAFD/24)", .csv)
  expect_equal(.d$TIME, c(0, 0.5, 1.25, 0, 0.25, 0))
  expect_equal(.d$TAFD, .d$TIME)
  .d <- .read("ID TIME=TAFD AMT II DV GEN", "IGNORE=@ TRANSLATE=(TIME/24)", .csv)
  expect_equal(.d$TIME, c(0, 0.5, 1.25, 0, 0.25, 0))
  expect_equal(.d$TAFD, .d$TIME)

  # RECORDS=n is applied before IGNORE; RECORDS=ID keeps the first subject
  .d <- .read("ID TIME AMT II DV GEN", "IGNORE=@ RECORDS=4 IGNORE=(GEN.EQ.F)", .csv)
  expect_equal(.d$TIME, c(0, 12, 30))
  .d <- .read("ID TIME AMT II DV GEN", "IGNORE=@ RECORDS=ID", .csv)
  expect_equal(.d$ID, c(1, 1, 1))
  .d <- .read("ID TIME AMT II DV GEN", "IGNORE=@ RECORDS=IR", .csv)
  expect_equal(.d$ID, c(1, 1, 1))
  .d <- .read("ID TIME AMT II DV GEN", "IGNORE=@ RECORDS=INDREC", .csv)
  expect_equal(.d$ID, c(1, 1, 1))
  # RECORDS=label with another data item (and its synonym)
  .d <- .read("ID TIME AMT II DV SEX=GEN", "IGNORE=@ RECORDS=GEN", .csv)
  expect_equal(.d$ID, c(1, 1, 1))

  # NULL= replaces nulls; MISDAT values are interpreted as 0
  .d <- .read("ID TIME AMT II DV GEN", "IGNORE=@ NULL=0 MISDAT=4", .csv)
  expect_equal(.d$DV, c(0, 5, 0, 0, 3, 0))

  # ACCEPT keeps only records meeting a condition (missing values do not)
  .acc <- c("ID,TIME,AMT,DV,GEN",
            "1,0,100,.,M",
            "1,1,0,5,.",
            "2,0,100,.,F")
  .d <- .read("ID TIME AMT DV GEN", "IGNORE=@ ACCEPT=(GEN.EQ.M)", .acc)
  expect_equal(.d$TIME, 0)
  .d <- .read("ID TIME AMT DV GEN", "IGNORE=@ IGNORE=(GEN.EQ.M)", .acc)
  expect_equal(.d$ID, c(1, 2))

  # NULL= is applied after the numeric IGNORE filters
  .nullCsv <- c("ID,TIME,AMT,DV,AGE",
                "1,0,100,.,100",
                "1,1,0,5,.",
                "2,0,100,.,40")
  .d <- .read("ID TIME AMT DV AGE", "IGNORE=@ NULL=0 IGNORE=(AGE.LE.60)", .nullCsv)
  expect_equal(.d$ID, c(1, 1))
  expect_equal(.d$AGE, c(100, 0))
  expect_equal(.d$DV, c(0, 5))

  # day-time translation of clock times happens before TRANSLATE
  .clock <- c("ID,TIME,AMT,II,DV",
              "1,08:00,100,12:30,.",
              "1,20:30,0,0,5",
              "2,07:15,100,1:00,.",
              "2,09:15:36,0,0,3")
  .d <- .read("ID TIME AMT II DV", "IGNORE=@", .clock)
  expect_equal(.d$TIME, c(0, 12.5, 0, 2.01))
  expect_equal(.d$II, c(12.5, 0, 1, 0))
  .d <- .read("ID TIME AMT II DV", "IGNORE=@ TRANSLATE=(TIME/24/4, II/24)", .clock)
  expect_equal(.d$TIME, round(c(0, 12.5, 0, 2.01) / 24, 4))
  expect_equal(.d$II, round(c(12.5, 0, 1, 0) / 24, 2))

  # dates (DATE=DROP still adjusts TIME)
  .date <- c("ID,DATE,TIME,AMT,DV",
             "1,12/31/99,23:00,100,.",
             "1,01/01/00,01:00,0,5",
             "1,1/2/2000,01:00,0,4")
  .d <- .read("ID DATE=DROP TIME AMT DV", "IGNORE=@", .date)
  expect_equal(.d$TIME, c(0, 2, 26))
  expect_false("DATE" %in% names(.d))
  # LAST20=-1 puts all two digit years in the 1900s
  .d <- .read("ID DATE=DROP TIME AMT DV", "IGNORE=@ LAST20=-1", .date[1:3])
  expect_equal(.d$TIME,
               c(0, 24 * as.numeric(as.Date("1900-01-01") - as.Date("1999-12-31")) - 22))
  # month/day dates without a year cross the year boundary (and allow 2/29)
  .md <- c("ID,DATE,TIME,AMT,DV",
           "1,12/31,23:00,100,.",
           "1,1/1,01:00,0,5",
           "2,2/28,00:00,100,.",
           "2,2/29,00:00,0,5",
           "2,3/1,00:00,0,5")
  .d <- .read("ID DATE=DROP TIME AMT DV", "IGNORE=@", .md)
  expect_equal(.d$TIME, c(0, 2, 0, 24, 48))
  # a month/day date continues from the year of a prior full date
  .mix <- c("ID,DATE,TIME,AMT,DV",
            "1,12/31/1998,00:00,100,.",
            "1,1/1,00:00,0,5",
            "2,2/28/1999,00:00,100,.",
            "2,3/1,00:00,0,5")
  .d <- .read("ID DATE=DROP TIME AMT DV", "IGNORE=@", .mix)
  expect_equal(.d$TIME, c(0, 24, 0, 24))
  # DAT1 is day month year
  .dat1 <- c("ID,DAT1,TIME,AMT,DV",
             "1,31-12-1999,23:00,100,.",
             "1,01-01-2000,01:00,0,5")
  .d <- .read("ID DAT1=DROP TIME AMT DV", "IGNORE=@ TRANSLATE=(TIME/24)", .dat1)
  expect_equal(.d$TIME, c(0, 0.08))
})
