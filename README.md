
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The powerbiR Package

<!-- badges: start -->
<!-- badges: end -->

The main goal of this package is to make it easy to implement real-time
dashboards using R and the Power BI REST API.

The following workflow is supported:

-   Create an empty Power BI push dataset from a list of data frames
-   Upload this dataset to Power BI Service
-   Populate the dataset with data
-   Push new data continuously to the dataset

A set of functions is also provided for managing administrative tasks
such as getting a list of datasets, refreshing imported datasets,
monitor refresh statuses and pulling useful metadata about workspaces
and users.

## Installation

You can install the development version of powerbiR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cvermehren/powerbiR")
```

## Authentication

To authenticate, you first of all need to create an app in the Power BI
Developer’s portal. This app will provide us with a reusable Client ID
and a Client Secret key, using which we can generate the embed token
required for the REST API.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
##library(powerbiR)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

<!-- You can also embed plots, for example: -->
<!-- ```{r pressure, echo = FALSE} -->
<!-- plot(pressure) -->
<!-- ``` -->
<!-- In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN. -->
