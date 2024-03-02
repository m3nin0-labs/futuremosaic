
# FutureMosaic ⌛️🛰️

`FutureMosaic` is an R package developed to create mosaics of raster
data. The package leverages the use of the `futures` package for
parallel processing. This package is useful for creating mosaics of
time-series data. By utilizing the GDAL capabilities, `FutureMosaic`
offers a simple yet powerful tool for spatio-temporal data mosaicking.

> **Note**: This is a **hobby project**

## Installation

You can install the development version of `futuremosaic` like so:

``` r
# install.packages("devtools")
# devtools::install_github("M3nin0/futuremosaic")
```

## Using FutureMosaic

To use `FutureMosaic`, first, prepare a data frame with the following
columns:

- `id`: Scene ID
- `collection`: Scene collection name
- `date`: Scene date
- `tile`: Scene tile
- `file`: Valid path to raster file

Then, you can call mosaic your data in the following way:

``` r
library(futuremosaic)

# Create the mosaics
temporal_mosaic(input_table, output_directory)
```

## Parallel Processing

Control the number of processes executed in parallel using the `future`
package:

``` r
library(future)

# Set future plan to multicore, adjust according to your system's capabilities
plan(multicore, workers = 4)

# Now run futuremosaic::temporal_mosaic as before
```
