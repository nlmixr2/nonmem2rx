> Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation. Please write about the structure of the output (class) and also what the output means. (If a function does not return a value, please document that too, e.g.
> \value{No return value, called for side effects} or similar) Missing Rd-tags:
>      autoplot.nonmem2rx.Rd: \value

Added value

> Please ensure that your functions do not write by default or in your examples/vignettes/tests in the user's home filespace (including the package directory and getwd()). This is not allowed by CRAN policies.
> Please omit any default path in writing functions. In your examples/vignettes/tests you can write to tempdir().

Turned off saving in tests/examples/vignettes. This should fix it

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
