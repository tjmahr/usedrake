
<!-- README.md is generated from README.Rmd. Please edit that file -->

# usedrake

<!-- badges: start -->

<!-- badges: end -->

The goal of usedrake is to make it easy to use drake. The package sets
up the files to use for a drake analysis.

## Installation

You can install usedrake from Github with:

``` r
remotes::install_github("tjmahr/usedrake")
```

## Example

For the purposes of demonstration, create a one-off empty directory.

``` r
# For the purposes of demonstration, work inside of a temporary folder
one_off_dir <- file.path(tempdir(), "usedrake-demo")
dir.create(one_off_dir)

# Everything is empty
dir(one_off_dir, recursive = TRUE)
#> character(0)
```

`use_drake()` will set up the project infrastruture in the folder.

``` r
usedrake::use_drake(one_off_dir)
#> Created file .here in C:\Users\Tristan\AppData\Local\Temp\RtmpqCv6e3\usedrake-demo
#> <U+2714> Setting active project to 'C:/Users/Tristan/AppData/Local/Temp/RtmpqCv6e3/usedrake-demo'
#> Warning: `recursive` is deprecated, please use `recurse` instead
#> <U+2714> Creating 'R/'
#> Warning: `recursive` is deprecated, please use `recurse` instead
#> <U+2714> Creating 'data/'
#> Warning: `recursive` is deprecated, please use `recurse` instead
#> <U+2714> Creating 'analysis/'
#> <U+2714> Writing 'R/packages.R'
#> <U+2714> Writing 'R/plan.R'
#> <U+2714> Writing 'R/functions.R'
#> <U+2714> Writing 'analysis/example.Rmd'
#> <U+2714> Writing '_drake.R'
#> <U+2714> Writing 'Makefile'
#> <U+25CF> Set Project Options > Build Tools to use a Makefile
#> <U+2714> Setting active project to '<no active project>'
```

These are the files that were created.

``` r
dir(one_off_dir, recursive = TRUE)
#> [1] "_drake.R"             "analysis/example.Rmd" "Makefile"            
#> [4] "R/functions.R"        "R/packages.R"         "R/plan.R"
```
