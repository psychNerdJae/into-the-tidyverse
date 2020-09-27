#### Initialize ####

# Libraries
library(tidyverse)
library(lubridate)
library(readxl)
library(janitor)
library(here)
library(gganimate)

# Pathing
path_data <- "Data"
path_save <- "Output"

# Read in hexmap of USA
hexmap <- here(path_data, "USA Hex Map", "hexmap.csv") %>%
  read_csv()
hexmap_labels <- here(path_data, "USA Hex Map", "hexmap_labels.csv") %>%
  read_csv()


#### Tidy urbanicity data ####

# CDC NCHS urban-rural classification scheme
# Downloaded from: https://www.cdc.gov/nchs/data_access/urban_rural.htm
urbanicity <- here(path_data, "NCHSURCodes2013.xlsx") %>%
  read_excel(na = c(".")) %>%
  clean_names() %>%
  select(fips_code, urbanicity = x2013_code, population = county_2012_pop) %>%
  mutate(urbanicity = recode(urbanicity,
                             `1`="1_central",
                             `2`="2_fringe",
                             `3`="3_medium",
                             `4`="4_small",
                             `5`="5_micro",
                             `6`="6_noncore"))


#### Tidy election data ####

# County-level presidential election returns
# Downloaded from: https://electionlab.mit.edu/data
elections <- here(path_data, "countypres_2000-2016.csv") %>%
  read_csv() %>%
  filter(year == 2016) %>%
  filter(party %in% c("democrat", "republican")) %>%
  group_by(state, county, FIPS) %>%
  mutate(lean_republican = candidatevotes / first(candidatevotes)) %>%
  ungroup() %>%
  filter(party == "republican") %>%
  select(state, county, FIPS, lean_republican)


#### Tidy covid data ####

# Get the latest dataset
covid_raw <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv" %>%
  read_csv()

# (Or read a copy downloaded on 09/25/2020)
# covid_raw <- here(path_data, "time_series_covid19_confirmed_US.csv") %>%
#   read_csv()

# Tidy
covid <- covid_raw %>%
  pivot_longer(cols = -c(UID:Combined_Key),
               names_to = "date", values_to = "cases") %>%
  clean_names() %>%
  select(-c(uid:code3, country_region)) %>%
  rename(county = admin2, state = province_state) %>%
  left_join(urbanicity, by = c("fips"="fips_code")) %>%
  left_join(elections %>% select(fips = FIPS, lean_republican)) %>%
  mutate(date = mdy(date))


#### Map cases ####

# Map: Total number of cases by state
hexmap %>%
  left_join(
    covid %>%
      filter(date == max(date)) %>%
      group_by(state) %>%
      summarise(cases = sum(cases)),
    by = c("id"="state")
  ) %>%
  ggplot(aes(x = long, y = lat, group = group)) +
  theme_void() +
  coord_map() +
  geom_polygon(aes(fill = cases), color="white") +
  scale_fill_binned() +
  geom_text(data=hexmap_labels,
            aes(x = x, y = y, label = id),
            color = "white",
            inherit.aes = FALSE) +
  NULL

# Map: Total number of cases by county
covid %>%
  filter(date == (today()-days(1))) %>%
  ggplot(aes(x = long, y = lat)) +
  theme_void() +
  geom_polygon(data = map_data("usa"),
               aes(x = long, y = lat, group = group),
               fill="grey10", color="black") +
  coord_map(xlim = c(-68, -125),
            ylim = c(20, 50)) +
  geom_point(aes(color = urbanicity, size = cases, alpha = cases)) +
  scale_color_viridis_d(option = "magma", begin = 0.4, direction = -1) +
  # scale_size_binned(range = c(0, 8)) +
  NULL


#### Plot cases over time ####

# Graph: Total number of cases by urbanicity type over time
covid %>%
  group_by(urbanicity, date) %>%
  summarise(cases = sum(cases)) %>%
  drop_na() %>%
  ggplot(aes(x = date, y = cases, color = urbanicity)) +
  theme_bw() +
  geom_line(size = 1) +
  scale_color_viridis_d() +
  NULL

# Animate graph: Total number of cases by urbanicity type over time
animate_cases <- covid %>%
  group_by(urbanicity, date) %>%
  summarise(cases = sum(cases)) %>%
  drop_na() %>%
  ggplot(aes(x = date, y = cases, color = urbanicity)) +
  theme_bw() +
  geom_line(size = 1) +
  scale_color_viridis_d() +
  labs(title = "Date: {frame_along}") +
  transition_reveal(date) +
  NULL

animate(animate_cases, end_pause = 20,
        width = 600, height = 400)

anim_save(here(path_save, "covid19 cases over time.gif"))

# Graph: Proportion of cases by urbanicity type over time
covid %>%
  group_by(urbanicity, date) %>%
  summarise(cases = sum(cases),
            population = sum(population),
            p_cases = cases/population) %>%
  drop_na() %>%
  ggplot(aes(x = date, y = p_cases, color = urbanicity)) +
  theme_bw() +
  geom_line(size = 1) +
  scale_color_viridis_d() +
  NULL


#### Rudimentary modeling ####

covid %>%
  filter(date == max(date)) %>%
  MASS::glm.nb(cases ~ population + urbanicity + lean_republican,
               data = .,
               contrasts = list(urbanicity = MASS::contr.sdif),
               maxit = 100) %>%
  broom::tidy() %>%
  mutate(rate_ratio = exp(estimate)) %>%
  mutate(sig = case_when(p.value < 0.001 ~ "***",
                         p.value < 0.01 ~ "**",
                         p.value < 0.05 ~ "*",
                         T ~ "")) %>%
  knitr::kable()


