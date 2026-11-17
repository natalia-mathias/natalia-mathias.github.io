################################################################################
# Script Name: data_cleaning.R
# Author: Natalia Mathias
# GitHub: natalia-mathias
# Date Created: November 16, 2026
#
# Purpose: This script cleans the raw World Bank (WDI) data for my project on
# countries whose life expectancy is higher or lower than their GDP per capita
# would suggest. It removes regional aggregates, keeps the variables I need,
# drops rows missing GDP or life expectancy, and saves a cleaned .Rds file.
#
################################################################################
# Load necessary libraries/source any functions
library(dplyr)
library(here)

################################################################################
# How the raw data was retrieved (run once; do not re-run)
# The raw file was downloaded from the World Bank API with {WDI} and saved so
# the project does not depend on the API staying the same:
#
# world_data <- WDI::WDI(
#   country = "all",
#   indicator = c(
#     gdp_per_capita = "NY.GDP.PCAP.CD",
#     life_expectancy = "SP.DYN.LE00.IN"
#   ),
#   start = 2000,
#   end = 2024,
#   extra = TRUE
# )
# saveRDS(
#   object = world_data,
#   file = here("pages", "project", "data", "world_bank_raw.Rds"),
#   compress = TRUE
# )

################################################################################
# read raw data with {here} for path management
world_bank_raw <- readRDS(
  file = here("pages", "project", "data", "world_bank_raw.Rds")
)

################################################################################
# clean data

world_bank_cleaned <-
  world_bank_raw |>
  # remove regional and income-group aggregates (e.g., "World", "Euro area")
  # so that every row is an individual country
  filter(
    region != "Aggregates",
    !is.na(region)
  ) |>
  # keep only the variables needed for the project
  select(
    country,
    iso3c,
    region,
    income,
    year,
    gdp_per_capita,
    life_expectancy
  ) |>
  # drop country-years missing either main variable
  filter(
    !is.na(gdp_per_capita),
    !is.na(life_expectancy)
  ) |>
  # sort by country and year for easier inspection
  arrange(
    country,
    year
  )

################################################################################
# save cleaned data as .Rds file with {here} for path management

saveRDS(
  object = world_bank_cleaned,
  file = here("pages", "project", "data", "cleaned", "world_bank_cleaned.Rds")
)

################################################################################
# End of script
