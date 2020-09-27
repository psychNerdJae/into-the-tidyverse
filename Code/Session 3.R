#### Initialize ####

# Libraries
library(readr)
library(tibble)
library(here)
library(tictoc)

# Dataset adapted from City of Providence, RI:
# https://data.providenceri.gov/Neighborhoods/2020-Property-Tax-Roll/y9h5-fefu


#### Read using base R ####

# Time how long it takes
tic()
base_read <- here("Data", "PVD_2020_Property_Tax_Roll.csv") %>%
  read.csv()
toc()

# Take a look at the data structure
head(base_read)
str(base_read)


#### Read using tidyverse ####

# Time how long it takes
tic()
tidy_read <- here("Data", "PVD_2020_Property_Tax_Roll.csv") %>%
  read_csv()
toc()

# Take a look at the data structure
head(tidy_read)
str(tidy_read)

# What if readr made a mistake? What if we want to manually specify our datatypes?
tidy_read_mod <- here("Data", "PVD_2020_Property_Tax_Roll.csv") %>%
  read_csv(col_types = cols(ZIP_POSTAL = col_character(),
                            plat = col_character()))

head(tidy_read_mod)
str(tidy_read_mod)


