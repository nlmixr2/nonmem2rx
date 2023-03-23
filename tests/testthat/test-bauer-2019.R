if (identical(Sys.getenv("NOT_CRAN"), "true")) {
  
  files <- c("mods/bauer_2019_cptpsp_tutorial_2/supp4/wexample10_lap.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp4/wexample10_bayes.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp4/wexample10_saem.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp2/504_foce.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp2/504_its.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp2/504_nuts.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp2/504_saem.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp2/504_bayes.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp6/superid30_1_foce.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp6/superid30_1_imp.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp6/superid30_1_bayes.ctl",
             # no COMACT
             # "mods/bauer_2019_cptpsp_tutorial_2/supp3/ad3tr4_loqb_lap.ctl",
             # "mods/bauer_2019_cptpsp_tutorial_2/supp3/ad3tr4_loqb_imp.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp5/r2complb_foce3.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp5/r2complb_foce4.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp5/r2complb_imp.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp5/r2complb_foce.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_saem.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_foce.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_bayes.ctl",
             # unsupported solved system cmt
             # "mods/bauer_2019_cptpsp_tutorial_2/supp8/urine.ctl",
             "mods/bauer_2019_cptpsp_tutorial_2/supp8/urine2.ctl",
             "mods/bauer_2019_cptpsp_tutorial_1/supp2/504.ctl",
             "mods/bauer_2019_cptpsp_tutorial_1/supp2/504f.ctl",
             "mods/bauer_2019_cptpsp_tutorial_1/supp1/402.ctl")

  withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE,
                           nonmem2rx.extended=FALSE),{
                             lapply(files,function(x) {
                               test_that(paste(x, ", regular"), {
                                 expect_error(nonmem2rx(system.file(x, package="nonmem2rx")), NA)
                               })
                             })
                           })


}
