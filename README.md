
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The powerbiR Package

<!-- badges: start -->
<!-- badges: end -->

The main goal of this package is to make it easy to implement (near)
real-time dashboards using R and the Power BI REST APIs.

The following workflow is supported:

-   Create an empty Power BI push dataset from a list of data frames
-   Upload this empty dataset to your Power BI Service account
-   Populate the dataset with data
-   Append new data at short intervals to the dataset

The package includes a set of functions for managing administrative
tasks such as getting a list of datasets, refreshing imported datasets,
monitoring refresh statuses and pulling useful metadata about workspaces
and users.

## Motivation

The powerbiR package was developed as part of a project aiming to create
a Google Analytics 4 (GA4) dashboard with live data during Black Friday.

GA4 can stream data directly to Google BigQuery. From there you can pull
data every few minutes and push them to Power BI using this package.

Live GA4 data are especially valuable for online retailers who want to
optimize their digital campaigns during important events such as Black
Friday.

## Installation

You can install the development version of powerbiR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cvermehren/powerbiR")
```

## Authentication

To authenticate, you first of all need to create a service principal
with permission to use Power BI REST APIs. This requires permission to
create an Azure AD Security Group and the Power BI Admin role.

The overall steps are:

-   Create a service principal (app registration) in Azure, including a
    client secret, and add it to a security group
-   Enable service principals to use Power BI APIs in the Power BI Admin
    Portal and apply this to the security group
-   Add the service principal (the app) as a member of the relevant
    Power BI workspaces
-   Use the tenant ID, app ID and client secret of the service principal
    to authenticate with `pbi_auth()`

The client secret is available immediately after creating it during app
registration. The tenant and app IDs can be found on the overview page
of your registered app in Azure.

See [Microsoft’s
guidelines](https://docs.microsoft.com/en-us/power-bi/developer/embedded/embed-service-principal#create-a-security-group-manually)
or this
[article](https://forwardforever.com/how-to-use-service-principal-in-power-bi-admin-rest-api-in-power-automate/)
for more details on using service principals for the Power BI Rest APIs.

#### Basic authentication

Using credentials from a service principal, you can authenticate in the
following way:

``` r
library(powerbiR)

pbi_auth(
  tenant = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", # The tenant ID
  app = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",    # The app ID
  password = "****"                                # The client secret
  )
```

#### Using environment variables

Exposing credentials directly in your code is not recommended. A better
way is to save them as environment variables in a file named
`.Renviron`.

The file should specify your credentials like this:

``` r
PBI_TENANT = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"   # The tenant ID 
PBI_APP = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"      # The app ID
PBI_PW = "****"                                       # The client secret
```

By default `pbi_auth()` retrieves these variables using `Sys.getenv()`,
which means you can authenticate without modifying the arguments of the
function:

``` r
pbi_auth() # Authentication with environment variables in the .Renviron file
```

#### Automatic token refresh

Authentication is based on a token returned by Azure when you call
`pbi_auth()`. This token has an expiration time, usually one hour after
retrieval.

The powerbiR package includes automatic refresh of the token after
expiration, which means you only need to authenticate once during an R
session.

## Pushing data to Power BI

After successful authentication, you can start pushing data to a Power
BI workspace.

The first step is to get the ID of the workspace (in the API referred to
as group ID):

``` r
# Get a list of workspace IDs
group_ids <- pbi_list_groups()

# Get the ID of the relevant workspace
group_ids <- group_ids$id[1]
```

A Power BI dataset consists of a number of tables which may or may not
be related with primary and foreign keys. Each column in each table must
be defined

Suppose you simply want to push the `iris` data frame to your Power BI
workspace.

You can do this in three simple steps:

1.  Infer the Power BI schema from the `iris` data frame:

``` r
schema <- pbi_schema_create(
  dt_list = list(iris),                # This is the data frame you want to push
  dataset_name = "The iris dataset",   # This is the dataset name you will see in Power BI
  table_name_list = "iris"             # This is the table name you will see in Power BI
  )
```

2.  Push the schema to your Power BI workspace:

``` r
# Get the workspace ID from its URL in Power BI Service
# or retrieve it through pbi_list_groups()
workspace_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

pbi_push_dataset(schema, workspace_id)
```

3.  Append data to the schema:

``` r

# Retrieve 

pbi_push_rows(iris, workspace_id)
```

``` r

schema
# $name
# [x] "The iris dataset"
# 
# $defaultMode
# [x] "Push"
# 
# $tables
# $tables[[1]]
#    name           columns
# 1: iris <data.table[5x3]>
```

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
