
## Cleaning WCPFC BET Catch Limits 

# We have manually compiled longline catch quotas for BET for the last few years. These were pieced together from a variety of different sources. 

# Packages
library(readxl)
library(tidyverse)
library(countrycode)

source(here::here("scripts", "00_setup.R"))

# Load in data
quota_dat <- read_xlsx(path = file.path(project_path, "data", "raw", "wcpfc_bet_catch_quotas.xlsx"))

# Tidy
quota_dat_tidy <- quota_dat %>%
  dplyr::select(-sources) %>%
  gather(year, quota, -flag_name) %>%
  mutate(flag_iso3 = countrycode(flag_name, "country.name", "iso3c"),
         flag_iso2 = countrycode(flag_name, "country.name", "iso2c"))

# Save
write_csv(quota_dat_tidy, file.path(clean_dir, "wcpfc_bet_quota_dat_tidy_2014_2020.csv"))
