test_that("tables test", {
  
  .t <- function(rec, eq="no") {
    .Call(`_nonmem2rx_setRecord`, "$TAB")
    .clearNonmem2rx()
    nonmem2rxRec.tab(rec)
    expect_equal(.nonmem2rx$tables, eq)
  }
  
  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4\nIPRED IRES IWRES CWRESI\nONEHEADER NOPRINT FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = TRUE, digits=4L)))

  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4\nIPRED IRES IWRES CWRESI\nONEHEADER NOPRINT NOAPPEND FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = FALSE, fullData = TRUE, hasIpred = TRUE, hasEta = TRUE, digits=4L)))

  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4\nIPRED IRES IWRES PRED CWRESI\nONEHEADER NOPRINT NOAPPEND FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = TRUE, digits=4L)))
  
  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2\nIPRED IRES IWRES CWRESI\nONEHEADER NOPRINT FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = FALSE, digits=4L)))

  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4\n IRES IWRES CWRESI\nONEHEADER NOPRINT FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = TRUE, hasIpred = FALSE, hasEta = TRUE, digits=4L)))

  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2\nIPRED ETAS(1,LAST) IRES IWRES CWRESI\nONEHEADER NOPRINT FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = TRUE, digits=4L)))

  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2\nIPRED ETA(1,LAST) IRES IWRES CWRESI\nONEHEADER NOPRINT FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = TRUE, digits=4L)))

  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4\nIPRED IRES IWRES CWRESI\n FIRSTONLY ONEHEADER NOPRINT FILE=runODE032.csv",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = FALSE, hasIpred = TRUE, hasEta = TRUE, digits=4L)))

  .t("  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4\nIPRED IRES IWRES CWRESI\n FIRSTONLY ONEHEADER NOPRINT FILE=runODE032.csv FORMAT=s1PE17.9",
     list(list(file = "runODE032.csv", hasPred = TRUE, fullData = FALSE, hasIpred = TRUE, hasEta = TRUE, digits=9L)))

  # #262 VARCALC= and FIXEDETAS= are accepted and ignored
  .t("ID TIME EVID MDV IPRED IRES IWRES CWRES\nVARCALC=1 NOPRINT ONEHEADER FILE=sdtab01 ; Standard table file",
     list(list(file = "sdtab01", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = FALSE, digits=4L)))

  .t("ID TIME IPRED\nFIXEDETAS=(1,3-4) varcalc=3 NOPRINT FILE=sdtab02",
     list(list(file = "sdtab02", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = FALSE, digits=4L)))

  .t("ID TIME IPRED\nFIXEDETAS=(01 2-3) VARCALC=0 NOPRINT FILE=sdtab03",
     list(list(file = "sdtab03", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = FALSE, digits=4L)))

  .t("ID TIME IPRED\nFIXEDETAS=2 VARCALC=2 NOPRINT FILE=sdtab04",
     list(list(file = "sdtab04", hasPred = TRUE, fullData = TRUE, hasIpred = TRUE, hasEta = FALSE, digits=4L)))

  # the value of an unsupported KEY=VALUE option is not a table column
  .t("ID TIME\nFOO=ETA1 BAR=IPRED FILE=sdtab05",
     list(list(file = "sdtab05", hasPred = TRUE, fullData = TRUE, hasIpred = FALSE, hasEta = FALSE, digits=4L)))

  expect_error(.t("ID TIME VARCALC=4 FILE=sdtab06"))
  expect_error(.t("ID TIME VARCALC=ETA1 FILE=sdtab07"))

  expect_error(.t("fun=funny.csv"))

})



