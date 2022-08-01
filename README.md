
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The powerbiR Package

<!-- badges: start -->
<!-- badges: end -->

The goal of this package is to make it easy to implement (near)
real-time dashboards using R and the Power BI REST APIs.

The following workflow is supported:

-   Create a Power BI dataset schema from a list of data frames
-   Upload this schema as an empty dataset to a Power BI workspace
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

To authenticate, you first of all need to create a service principal in
Azure with access to Power BI REST APIs. This requires permission to
create an Azure AD Security Group and the Power BI Admin role.

The overall steps are:

-   Create a service principal (app registration) in Azure, including a
    client secret, and add it to a security group
-   Enable service principals to use Power BI APIs in the Power BI Admin
    Portal and apply this setting to the security group
-   Add the service principal (the app) as a member of the Power BI
    workspaces to which you want to push data
-   Use the tenant ID, app ID and client secret of the service principal
    to authenticate with `pbi_auth()`

The client secret is available immediately after creating it during app
registration. The tenant and app IDs can be found on the overview page
of your registered app in Azure.

See [Microsoft’s
guidelines](https://docs.microsoft.com/en-us/power-bi/developer/embedded/embed-service-principal#create-a-security-group-manually)
and the first few sections of this
[article](https://forwardforever.com/how-to-use-service-principal-in-power-bi-admin-rest-api-in-power-automate/)
for more details on using service principals for the Power BI Rest APIs.

#### Basic authentication

Using a service principal, you can authenticate in the following way:

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

This is supported by `pbi_auth()` as long as you specify your
credentials in the `.Renviron` like this:

``` r
PBI_TENANT = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"   # The tenant ID 
PBI_APP = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"      # The app ID
PBI_PW = "****"                                       # The client secret
```

By default `pbi_auth()` retrieves these variables using `Sys.getenv()`,
which means you can now authenticate without modifying the arguments of
the function:

``` r
# Authentication with environment variables in the .Renviron file
pbi_auth()
```

#### Automatic token refresh

Authentication is based on a token returned by Azure when you call
`pbi_auth()`. This token has an expiration time, usually one hour after
retrieval.

The powerbiR package handles automatic refresh of the token after
expiration, which means you only need to authenticate once during an R
session.

## Create a Power BI dataset schema

After successful authentication, you can start pushing data to a Power
BI workspace. The first step is to create a schema for a Power BI
dataset which includes definitions of tables, relationships, columns and
column formats.

The powerbiR package automates this task as far as possible by inferring
data types and generating list objects with definitions from the data
frames you want to push to Power BI.

``` r
# Load the demo data included in this package
data(dim_hour)
data(fact_visitors)

# Define the Power BI dataset with one or more data frames
dataset_name <- c("Online Visitors")
table_names  <- c("visitors", "hour")
table_list <- list(fact_visitors, dim_hour)

# Define one or more relationships between tables (here only from_column is
# specified since to_column has the same name)
relation <- list(
  pbi_schema_relation_create(
    from_table = "visitors",
    from_column = "hour_key",
    to_table = "hour"
    )
  )

# Create the schema
 schema <- pbi_schema_create(
   dt_list = table_list,
   dataset_name = dataset_name,
   table_name_list = table_names,
   relations_list = relation
   )
```

This schema returns a list object designed to be converted into JSON and
used as the body in a request to the Power REST API.

## Upload the schema to Power BI

The next step is to upload the schema as an empty dataset to a Power BI
workspace. Before doing so, you need to obtain the ID of the workspace
you are planning to push data to.

``` r
# Get a data frame with workspaces available to the service principal
# (workspaces are called "groups" in the API)
groupid_df <- pbi_list_groups()

# Get the ID of the workspace in question, here we use the first in the list
groupid <- groupid_df$id[1]
```

You are now ready to upload the schema.

``` r
# Push the schema to the specified workspace (groupid) in Power BI
new_dataset_id <- pbi_push_dataset_schema(schema, groupid)
#> Successfully added dataset schema to the workspace with ID xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

The above function returns the ID of the created dataset. You need this
for populating the dataset with data.

## Populate the dataset with data

The last step is to push data to the empty dataset you have just created
in Power BI.

``` r
# Using the new_dataset_id, iterate over the list of tables in the dataset
for (i in seq_along(table_list)) {
  pbi_push_rows(
    dt = table_list[[i]], 
    group_id = group_id, 
    dataset_id = new_dataset_id, 
    table_name = table_names[i],
    overwrite = FALSE
    )
}
#> Successfully added 10000 rows to visitors
#> Successfully added 33 rows to visitors
#> Successfully added 24 rows to hour
```

The visitors data frame has 10,033 observations. `pbi_push_rows`
automatically splits the data frame into chunks of 10K rows before
uploading since the Power BI API has a limit of 10K rows per request.

Using the above for-loop, you can append new data to the dataset at
short intervals as long as you don’t exceed the limitations of the push
dataset APIs (for more details, visit the page [Push datasets
limitations](https://docs.microsoft.com/en-us/power-bi/developer/embedded/push-datasets-limitations)).

## Creating reports and dashboards in Power BI

With data in Power BI service you can start building reports and
dashboards. Although you can do this directly in Power BI service, a
more flexible approach is to connect to the dataset from Power BI
Desktop, create your report locally and then publish the .pbix file.

Power BI Desktop has more data-modeling and report-authoring features
than the online version. You can define new measures and columns using
DAX and it has more options for controlling visuals, report layout and
interactivity.

For more details on this approach, see [Connect to datasets in the Power
BI service from Power BI
Desktop](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-report-lifecycle-datasets).
