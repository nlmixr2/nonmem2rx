# Reads the NONMEM `.ext` file for final parameter information

Reads the NONMEM `.ext` file for final parameter information

## Usage

``` r
nmext(file)
```

## Arguments

- file:

  File where the list is located

## Value

return a list with `$theta`, `$eta` and `$eps`

## Author

Matthew L. Fidler

## Examples

``` r
nmext(system.file("run001.ext", package="nonmem2rx"))
#> $theta
#>      theta1      theta2      theta3      theta4      theta5      theta6 
#> 26.29090000  1.34809000  4.20364000  0.20795800  0.20461000  0.01055270 
#>      theta7 
#>  0.00717161 
#> 
#> $omega
#>           eta1      eta2    eta3
#> eta1 0.0729525 0.0000000 0.00000
#> eta2 0.0000000 0.0380192 0.00000
#> eta3 0.0000000 0.0000000 1.90699
#> 
#> $sigma
#>      eps1
#> eps1    1
#> 
#> $objf
#> [1] -1403.905
#> 
```
