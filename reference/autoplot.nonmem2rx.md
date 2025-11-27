# Autoplot nonmem2rx object

Autoplot nonmem2rx object

## Usage

``` r
# S3 method for class 'nonmem2rx'
autoplot(
  object,
  ...,
  ncol = 3,
  nrow = 3,
  log = "",
  xlab = "Time",
  ylab = "Predictions",
  page = FALSE
)
```

## Arguments

- object:

  an object, whose class will determine the behaviour of autoplot

- ...:

  ignored parameters for `nonmem2rx` objects

- nrow, ncol:

  Number of rows and columns

- log:

  Should "" (neither x nor y), "x", "y", or "xy" (or "yx") be log-scale?

- xlab, ylab:

  The x and y axis labels

- page:

  number of page(s) for the individual plots, by default (`FALSE`) no
  pages are print; You can use `TRUE` for all pages to print, or list
  which pages you want to print

## Value

a ggplot2 object
