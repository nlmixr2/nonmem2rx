test_that("bad read for xml", {
  
  expect_true(inherits(.nmxmlGetCov(xml2::xml_find_first(xml2::read_xml(test_path("issue-144.xml")), "//nm:covariance")),
               "matrix"))
  
})
