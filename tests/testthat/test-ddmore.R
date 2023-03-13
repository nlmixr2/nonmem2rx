if (identical(Sys.getenv("NOT_CRAN"), "true")) {
  files <- c("ddmore/267/Output_simulated_OriginalModelCode.lst",
             "ddmore/267/Executable_OriginalModelCode.mod",
             "ddmore/267/Output_real_OriginalModelCode.lst",
             "ddmore/198/Executable_TGI_GIST.mod",
             "ddmore/238/Executable_run35b_ddm2.mod",
             "ddmore/238/Output_real_run35b.lst",
             "ddmore/243/Output_simulated_runEV1_201.res",
             "ddmore/243/Executable_runEV2_105.ctl",
             "ddmore/243/Executable_runCOMPEV2_005.mod",
             "ddmore/243/Executable_runEV2_105.mod",
             "ddmore/243/Executable_runCOMPEV1_101.mod",
             "ddmore/243/Output_simulated_runEV2_105.res",
             "ddmore/243/Output_simulated_runCOMPEV2_005.res",
             "ddmore/243/Output_simulated_runCOMPEV1_101.res",
             "ddmore/243/Executable_runEV1_201.mod",
             "ddmore/290/Executable_simulated_CPathAD.mod",
             "ddmore/290/Output_real_CPathAD.lst",
             "ddmore/290/Output_simulated_CPathAD.lst",
             "ddmore/271/Output_simulated_ParacetamolInNewborns.lst",
             "ddmore/271/Executable_ParacetamolInNewborns.mod",
             "ddmore/271/Output_real_ParacetamolInNewborns.lst",
             "ddmore/198/Output_real_TGI_GIST.lst",
             "ddmore/198/Output_simulated_TGI_GIST.lst",
             "ddmore/197/Output_simulated_Biomarker_GIST.lst",
             "ddmore/197/Output_real_Biomarker_GIST.lst",
             "ddmore/197/Executable_Biomarker_GIST.mod",
             # Can't figure out central
             #"ddmore/284/Output_simulated_SIMNIVO_PPK.lst",
             #"ddmore/284/Output_real_Nivo-PPK.lst",
             "ddmore/280/TB_Rifampicin_PK_Wilkins_2008_simulated.lst",
             "ddmore/280/Executable_real_TB_Rifampicin_PK_Wilkins_2008.mod",
             "ddmore/280/Executable_simulated_TB_Rifampicin_PK_Wilkins_2008.mod",
             "ddmore/250/Executable_AccessWeightModelCode.mod",
             "ddmore/250/Output_real_AccessWeightModelCode.lst",
             "ddmore/250/Output_real_FinalModelCode.lst",
             "ddmore/250/Executable_FinalModelCode.mod",
             "ddmore/250/Output_simulated_FinalModelCode.lst",
             "ddmore/250/Output_simulated_AccessWeightModelCode.lst",
             "ddmore/298/Output_simulated_sultiame_nonlinear_PK.lst",
             "ddmore/298/Executable_sultiame_nonlinear_PK.mod",
             "ddmore/298/Output_real_sultiame_nonlinear_PK.lst",
             # does not work in ci
             ## "ddmore/261/Output_real_SAEM_KPD_CTC.count_PSA.lst",
             ## "ddmore/261/Output_real_COV_KPD_CTC.count_PSA.lst",
             "ddmore/261/Executable_simulated_KPD_CTC.count_PSA.mod",
             "ddmore/261/Output_simulated_KPD_CTC.count_PSA.lst",
             "ddmore/256/Output_simulated_OriginalModelCode.lst",
             "ddmore/256/Executable_OriginalModelCode.mod",
             "ddmore/256/Output_real_run522.lst",
             "ddmore/213/Output_simulated_Meropenem.lst",
             "ddmore/249/Output_simulated_OriginalModelCode.lst",
             "ddmore/249/Executable_OriginalModelCode.mod",
             "ddmore/249/Output_real_OriginalModelCode.lst",
             "ddmore/262/Executable_simulated_CPHPC_dataset.ctl",
             "ddmore/262/Output_simulated_CPHPC_dataset.lst",
             "ddmore/217/Output_real_SLD.lst",
             "ddmore/217/Output_simulated_SLD.lst",
             "ddmore/217/Executable_SLD.mod",
             "ddmore/247/Output_simulated_OriginalModelCode.lst",
             "ddmore/247/Output_real_OriginalModelCode.lst",
             "ddmore/294/Executable_Paracetamol_Zebrafish_345dpf.mod",
             "ddmore/294/Output_real_Paracetamol_Zebrafish_345dpf.lst",
             "ddmore/223/Output_simulated_Novakovic_2016_multiplesclerosis_cladribine_irt.lst",
             "ddmore/223/Executable_Novakovic_2016_multiplesclerosis_cladribine_irt.mod",
             "ddmore/223/Output_real_Novakovic_2016_multiplesclerosis_cladribine_irt.lst",
             "ddmore/219/Output_simulated_executable_BDQ_M2_PK_plus_WT_ALB_in_MDR-TB_patients.lst",
             "ddmore/219/Executable_BDQ_M2_PK_plus_WT_ALB_in_MDR-TB_patients.mod",
             "ddmore/219/Output_real_BDQ_M2_PK_plus_WT_ALB_in_MDR-TB_patients.lst",
             ## dosen't work in ci
             ## "ddmore/228/Output_simulated_run126h.lst",
             ## "ddmore/228/Output_real_run126c.lst",
             ## "ddmore/228/Executable_run126h.mod",
             "ddmore/195/Output_simulated_nca_simulation.1.lst",
             "ddmore/194/Output_real_likert_pain_count.lst",
             "ddmore/194/Executable_likert_pain_count.mod",
             "ddmore/194/Output_simulated_likert_pain_count.lst",
             "ddmore/295/Output_real_CMS_colistin_PK_CRRT.lst",
             "ddmore/295/Output_simulated_CMS_colistin_PK_CRRT - Copie.lst",
             "ddmore/295/Executable_CMS_colistin_PK_CRRT.mod",
             "ddmore/214/Executable_HFSmodel.mod",
             "ddmore/214/Output_simulated_HFSmodel.lst",
             "ddmore/214/Output_real_HFSmodel.lst",
             "ddmore/245/Output_simulated_Executable_run111.lst",
             "ddmore/245/Executable_run111.mod",
             "ddmore/273/Output_simulated_Dupilumab.lst",
             "ddmore/273/Executable_Simulated_Dupilumab.ctl",
             "ddmore/218/Output_simulated_OS.lst",
             "ddmore/218/Output_real_OS.lst",
             "ddmore/218/Executable_OS.mod",
             ## advan
             ## "ddmore/248/Output_simulated_OriginalModel Code.lst",
             ## "ddmore/248/Executable_OriginalModelCode.mod"
             ## "ddmore/248/Output_real_run4.lst",
             "ddmore/222/Output_real_Fatigue_GIST.lst_Fatigue_PSP_2014",
             "ddmore/222/Output_simulated_Fatigue_GIST.lst",
             "ddmore/222/Executable_Fatigue_GIST.mod",
             "ddmore/221/Output_real_SLD_SUV_OS_GIST.lst",
             "ddmore/221/Executable_SLD_SUV_OS_GIST.mod",
             "ddmore/221/Output_simulated_SLD_SUV_OS_GIST.lst",
             "ddmore/224/Executable_myelosuppression_dailyANC.mod",
             "ddmore/224/Output_simulated_Executable_myelosuppression_dailyANC.lst",
             "ddmore/244/Output_real_Rif_PK.lst",
             "ddmore/244/Output_simulated_Rif_PK.lst",
             "ddmore/244/Executable_Rif_PK.mod",
             "ddmore/301/Executable_merop_PK_run3.mod",
             "ddmore/301/Output_simulated_merop_PK_run3.lst",
             "ddmore/301/Output_real_merop_PK_run3.lst",
             "ddmore/274/Terranova_2017_oncology_TGI.ctl",
             "ddmore/274/Executable_Terranova_2017_oncology_TGI_HM.ctl",
             "ddmore/212/Output_simulated_tamoxifen.lst",
             "ddmore/215/Output_simulated_Pimasertib_AeDropout.lst",
             "ddmore/215/Output_real_Pimasertib_AeDropout.lst",
             "ddmore/215/Executable_Pimasertib_AeDropout.mod"
             # mtime
             ## "ddmore/239/Executable_P241.ctl"
             )


  # mixture models
  ## "ddmore/239/Output_simulated_P241.res",
  ## "ddmore/239/Output_real_P241.res",
  # multiple $data records
  ## "ddmore/239/Simulate_P241.ctl"

  filesErors <- c(#f0
    "ddmore/238/Output_simulated_run35b_ddm2.lst",
    "ddmore/240/Executable_MTP.mod",
    "ddmore/240/Output_simulated_MTP.lst",
    "ddmore/240/Output_real_MTP.lst",
    "ddmore/259/Output_simulated_MTP-GPDI.lst",
    "ddmore/259/Executable_MTP-GPDI.mod",
    # bad formed $theta
    # bad advan
    "ddmore/220/Executable_run32150.mod",
    "ddmore/220/Finmod_7_3.lst",
    "ddmore/220/Output_real_run32150.lst",
    "ddmore/220/Output_simulated_Executable_run32150.lst",
    "ddmore/281/Output_simulated_ddmore_final_run249.res",
    "ddmore/281/Output_real_data_original_final_run249.res",
    "ddmore/281/Executable_ddmore_final_run249.ctl",
    "ddmore/269/Output_simulated_ModelI_Morphine.lst",
    "ddmore/269/Executable_ModelII_MM3G.mod",
    "ddmore/269/Executable_ModelI1_Morphine.mod",
    "ddmore/297/Output_simulated_run1.lst",
    "ddmore/297/Executable_run1.mod",
    "ddmore/268/Output_real_PK_rats.lst",
    "ddmore/268/Output_simulated_PK_rats.lst",
    "ddmore/268/Executable_PK_rats.txt",
    # bad formed $prob statement
    "ddmore/284/Executable_Simulated_IMNIVO_PPK.CTL",
    "ddmore/284/NIVO-PPKFinalModel-CPT.CTL",
    # no control in output
    "ddmore/262/Output_real_CPHPC.lst",
    "ddmore/269/Output_real_ModelII_MM3G.lst",
    "ddmore/269/Output_real_ModelI_Morphine.lst",
    "ddmore/269/Output_simulated_ModelII_MM3G.lst")

  # Probably should work:
  # "ddmore/173/ColistinMeropenem_Interaction_original_simulated.mod"
  # "ddmore/173/Output_simulated_ColistinMeropenem_Interaction.lst"
  # "ddmore/173/Executable_ColistinMeropenem_Interaction.mod",
  # "ddmore/173/Output_real_ColistinMeropenem_interaction.lst",

  # probably won't support; has thetas that are defined by math
  # "ddmore/247/Executable_OriginalModelCode.mod",


  # shouldn't work bad theta
  # 

  withr::with_tempdir({
    unzip(system.file("ddmore.zip", package="nonmem2rx"))
    lapply(files,function(x) {
      test_that(x, {
        expect_error(suppressMessages(suppressWarnings(nonmem2rx(x))), NA)
      })
    })
  })
}

