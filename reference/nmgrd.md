# Reads the NONMEM `.grd` file for final parameter gradient

Reads the NONMEM `.grd` file for final parameter gradient

## Usage

``` r
nmgrd(file)
```

## Arguments

- file:

  File where the list is located

## Value

return a list with `$rawGrad`

## Author

Matthew L. Fidler

## Examples

``` r

nmgrd(system.file("mods/cpt/runODE032.grd", package="nonmem2rx"))
#>    ITERATION       GRD(1)       GRD(2)       GRD(3)       GRD(4)       GRD(5) 
#>   25.0000000  560.0530000 1694.0100000   13.0952000 -115.0000000   -0.5077900 
#>       GRD(6)       GRD(7)       GRD(8)       GRD(9) 
#>   -0.2418040    0.0765655   -0.0282282   -0.1172670 
```
