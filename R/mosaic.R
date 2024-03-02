#
# Copyright (C) 2024 FutureMosaic package.
#
# FutureMosaic package is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#


#' Create mosaic of image based on time.
#'
#' @importFrom doFuture %dofuture%
#' @importFrom foreach foreach
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @description
#' This functions get images reference from a table, group them by date and
#' create mosaics using the images available in each group.
#'
#' @param images_table data.frame Table with the following columns:
#' - `id` (str): Scene ID
#' - `collection` (str): Scene collection Name
#' - `date` (Date): Scene date
#' - `tile` (str): Scene tile
#' - `file` (str): Valid path to raster file.
#'
#' @param output_dir str Output directory.
#'
#' @export
#'
#' @return ``data.frame`` containing the output files
temporal_mosaic <- function(images_table, output_dir) {
  if (!.dir_exists(output_dir)) {
    stop("Invalid directory")
  }

  # grouping data by data.
  image_group <- NULL

  image_groups <- images_table |>
    dplyr::group_by(date) |>
    dplyr::group_map(function(data, name) {
      list(data = data, name = name)
    })

  # process multiple mosaic in parallel
  output_files <-
    foreach::foreach(image_group = image_groups) %dofuture% {
      group_input_files <- base::unlist(image_group$data$file)
      group_name <- image_group$name$date[[1]]

      group_output_file <- base::paste0(lubridate::year(group_name),
                                        "_",
                                        lubridate::month(group_name),
                                        ".tiff")

      group_output_file <-
        base::as.character(fs::path(output_dir) / group_output_file)

      sf::gdal_utils(
        util = "warp",
        source = group_input_files,
        destination = group_output_file,
        options = c(
          "-multi",
          "-wo",
          "NUM_THREADS=ALL_CPUS",
          "-ot",
          "UInt16",
          "-srcnodata",
          "-1000"
        )
      )

      sf::gdal_addo(
        file = group_output_file,
        method = "NEAREST",
        overviews = c(2, 4, 8, 16),
        options = c("GDAL_NUM_THREADS" = "2")
      )

      group_output_file
    }

  unlist(output_files)
}
