#
# Copyright (C) 2024 FutureMosaic package.
#
# FutureMosaic package is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

#' Check if a give directory exists.
#'
#' @param output_directory Directory path
#'
#' @return ``bool`` flag indicating if the directory exists.
.dir_exists <- function(output_directory) {
  fs::dir_exists(output_directory)
}
