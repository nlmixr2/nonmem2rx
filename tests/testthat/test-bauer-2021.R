if (identical(Sys.getenv("NOT_CRAN"), "true")) {

  files <-c("mods/bauer_2021_cptpsp_design_tutorial/example6/tmdd2.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example7/tmdd2b.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example7/tmdd2c.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example7/optex6d17_8.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example1/warfarin.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example2/warfarin2b.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example2/warfarin2.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example2/warfarin2c.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example3/warfarin3b.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example3/priortrue2.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example3/priortrue.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example3/warfarin3c.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example5/optdesign2.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example5/optdesign2d.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example5/optdesign2c.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example4/warfarin_pkpd_eval.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example4/warfarin_pkpd_opt2.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example4/warfarin_pkpd_eval2.ctl",
            "mods/bauer_2021_cptpsp_design_tutorial/example4/warfarin_pkpd_opt.ctl")

  withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE,
                           nonmem2rx.extended=FALSE),{
                             lapply(files,function(x) {
                               test_that(paste(x, ", regular"), {
                                 expect_error(suppressMessages(suppressWarnings(nonmem2rx(system.file(x, package="nonmem2rx")))), NA)
                               })
                             })
                           })
}
