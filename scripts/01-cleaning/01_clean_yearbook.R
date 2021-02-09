
## Cleaning WCPFC Yearbook Data

# The WCPFC Yearbookincludes total catches by flag state and gear type for the following areas:
  #- WCPFC convention area
  #- North Pacific
  #- South Pacific
  #- Pacific

# We're primarily interested in the data for the WCPFC convention area as this is the area to which the BET catch quotas apply. 

# Packages
library(readxl)
library(tidyverse)
library(countrycode)

source(here::here("scripts", "00_setup.R"))

# Load raw data
yearbook_dat <- read_xlsx(path = file.path(project_path, "data", "raw", "YEARBOOK_XLS", "YB_WCP_CA.xlsx"))

# Tidy and add meaningful country names
yearbook_dat_tidy <- yearbook_dat %>%
  gather(species, catch, contains("_mt")) %>%
  mutate(species = str_replace(species, "_mt", ""),
         units = "mt",
         flag_name = case_when(flag == "EP" ~ "Eastern Pacific US Purse Seine Fleet",
                               flag == "SU" ~ "Soviet Union",
                               TRUE ~ countrycode(flag, "iso2c", "country.name")),
         flag_iso3 = case_when(flag == "EP" ~ "USA",
                               flag == "SU" ~ "SUN",
                               TRUE ~ countrycode(flag, "iso2c", "iso3c"))) %>%
  rename(year = yy, flag_iso2 = flag) %>%
  arrange(flag_iso2, year)

# Since SID status matters, let's add a column identifying whether a given country is a SID
sids <- c("Belize", "Fiji", "Kiribati", "Marshall Islands", "Micronesia (Federated States of)", "Nauru", "Palau", "Papua New Guinea", "Samoa", "Solomon Islands", "Timor-Leste", "Tonga", "Tuvalu", "Vanuatu", "American Samoa", "Commonwealth of Northern Marianas", "Cook Islands", "French Polynesia", "Guam", "New Caledonia", "Niue")
sids_iso3 <- countrycode(sids, "country.name", "iso3c")

# Apply to yearbook data
yearbook_dat_tidy <- yearbook_dat_tidy %>%
  mutate(is_SID = ifelse(flag_iso3 %in% sids_iso3, T, F))

# Save 
write_csv(yearbook_dat_tidy, file.path(clean_dir, "wcpfc_yearbook_dat_tidy_1950_2018.csv"))

# Let's extract just the data for the longline fleet while we're at it. 
yearbook_dat_ll <- yearbook_dat_tidy %>%
  dplyr::filter(gear == "L")

# Save 
write_csv(yearbook_dat_ll, file.path(clean_dir, "wcpfc_yearbook_dat_tidy_1950_2018_LL_ONLY.csv"))