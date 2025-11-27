# Record handling for nonmem records

Record handling for nonmem records

## Usage

``` r
# S3 method for class 'abb'
nonmem2rxRec(x)

# S3 method for class 'pk'
nonmem2rxRec(x)

# S3 method for class 'pre'
nonmem2rxRec(x)

# S3 method for class 'des'
nonmem2rxRec(x)

# S3 method for class 'mix'
nonmem2rxRec(x)

# S3 method for class 'err'
nonmem2rxRec(x)

# S3 method for class 'dat'
nonmem2rxRec(x)

# S3 method for class 'inp'
nonmem2rxRec(x)

# S3 method for class 'mod'
nonmem2rxRec(x)

# S3 method for class 'ome'
nonmem2rxRec(x)

# S3 method for class 'sig'
nonmem2rxRec(x)

# S3 method for class 'pro'
nonmem2rxRec(x)

# S3 method for class 'aaa'
nonmem2rxRec(x)

nonmem2rxRec(x)

# Default S3 method
nonmem2rxRec(x)

# S3 method for class 'sub'
nonmem2rxRec(x)

# S3 method for class 'tab'
nonmem2rxRec(x)

# S3 method for class 'the'
nonmem2rxRec(x)
```

## Arguments

- x:

  Nonmem record data item, should be of class c(stdRec, "nonmem2rx")
  where the stdRec is the standardized record (pro for `$PROBLEM`, etc)

## Value

Nothing, called for side effects

## Details

Can add record parsing and handling by creating a S3 method for each
type of standardized method

## Author

Matthew L. Fidler
