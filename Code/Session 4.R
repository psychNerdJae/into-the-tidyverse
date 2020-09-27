#### Introduction to functions ####

# Everything is (secretly) a function
# Functions take some inputs (known as arguments), apply some transformations,
# and then provide you with the output of those transformations
2 + 6
sum(2, 6)

# Functions don't always do what you think they do!
# When in doubt, check the documentation to see what the arguments are
mean(2, 6)
?mean
mean(c(2, 6))

# What's actually going on inside a function?
my_mean <- function(this_vector) {
  sum(this_vector) / length(this_vector)
}

my_mean(c(2,6))
my_mean(this_vector = c(2,6))


#### Libraries ####

library(here)

# You can pull a function from a library without loading the entire library:
readr::read_csv(here("Data", "time_series_covid19_confirmed_US.csv"))

# Libraries make it easy to access "bundles" of functions
library(readr)
read_csv(here("Data", "time_series_covid19_confirmed_US.csv"))

# dplyr provides you with useful tools for "wrangling" data
library(dplyr)


#### Manipulating data ####

# Read in the Johns Hopkins covid data
covid_raw <- here("Data", "time_series_covid19_confirmed_US.csv") %>%
  read_csv()

# Look for cases just in California
covid_ca <- covid_raw %>%
  filter(Province_State == "California") %>%
  select(fips = FIPS, county = Admin2, `9/18/20`:`9/24/20`)

# CDC NCHS urban-rural classification scheme
# Downloaded from: https://www.cdc.gov/nchs/data_access/urban_rural.htm
urbanicity <- here("Data", "NCHSURCodes2013.xlsx") %>%
  readxl::read_excel(na = c(".")) %>%
  janitor::clean_names() %>%
  select(fips_code, urbanicity = x2013_code, population = county_2012_pop)

# What if we want to know something about urbanicity? Or normalize by population?
covid <- covid_ca %>%
  left_join(urbanicity, by = c("fips"="fips_code"))

# Total number of cases by urbanicity
covid %>%
  group_by(urbanicity) %>%
  summarise(cases = sum(`9/24/20`))

# Mean number of cases by urbanicity
covid %>%
  group_by(urbanicity) %>%
  summarise(cases = mean(`9/24/20`))

# Mean proportion of cases in population, by urbanicity
covid %>%
  mutate(across(.cols = `9/18/20`:`9/24/20`,
                .fns = ~.x/population)) %>%
  group_by(urbanicity) %>%
  summarise(cases = mean(`9/24/20`)) %>%
  mutate(cases_percent = cases * 100,
         cases_percent = round(cases_percent, 0)) %>%
  arrange(cases)


