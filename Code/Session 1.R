#### Initialize ####

# Libraries
library(tidyverse)
library(lubridate)
library(readxl)
library(janitor)
library(here)
library(gganimate)

#### Tidy covid data ####

# Get the latest dataset
covid_raw <- str_c("https://raw.githubusercontent.com/CSSEGISandData/",
                   "COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/",
                   "time_series_covid19_confirmed_US.csv") %>%
  read_csv()

# Tidy
covid <- covid_raw %>%
  pivot_longer(cols = -c(UID:Combined_Key),
               names_to = "date", values_to = "cases") %>%
  clean_names() %>%
  select(-c(uid:code3, country_region)) %>%
  rename(county = admin2, state = province_state) %>%
  left_join(urbanicity, by = c("fips"="fips_code")) %>%
  mutate(date = mdy(date))


#### Tidy urbanicity data ####

# Tidy CDC NCHS urban-rural classification scheme
# Downloaded from: https://www.cdc.gov/nchs/data_access/urban_rural.htm
urbanicity <- str_c("~/Dropbox (Personal)/Teaching/Into the Tidyverse/",
                    "Session 1 (Motivating Example)/NCHSURCodes2013.xlsx") %>%
  read_excel() %>%
  clean_names() %>%
  select(fips_code, urbanicity = x2013_code) %>%
  mutate(urbanicity = recode(urbanicity,
                             `1`="1_central",
                             `2`="2_fringe",
                             `3`="3_medium",
                             `4`="4_small",
                             `5`="5_micro",
                             `6`="6_noncore"))

# Read in hexmap of USA
hexmap <- str_c("~/Dropbox (Personal)/Personal Geekery/USA Hex Map/hexmap.csv") %>%
  read_csv()
hexmap_labels <- str_c("~/Dropbox (Personal)/Personal Geekery/USA Hex Map/hexmap_labels.csv") %>%
  read_csv()


#### Tidy data ####

covid <- covid_raw %>%
  pivot_longer(cols = -c(UID:Combined_Key),
               names_to = "date", values_to = "cases") %>%
  clean_names() %>%
  select(-c(uid:code3, country_region)) %>%
  rename(county = admin2, state = province_state) %>%
  left_join(urbanicity, by = c("fips"="fips_code")) %>%
  mutate(date = mdy(date))


#### Plot data ####

# Total number of cases by state
hexmap %>%
  left_join(covid %>%
              filter(date == (today()-days(1))) %>%
              group_by(state) %>%
              summarise(cases = sum(cases)),
            by = c("id"="state")) %>%
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

# Total number of cases by county
covid %>%
  filter(date == (today()-days(1))) %>%
  ggplot(aes(x = long, y = lat)) +
  theme_void() +
  geom_polygon(data = map_data("usa"),
             aes(x = long, y = lat, group = group),
             fill="grey95", color="grey50") +
  coord_map(xlim = c(-68, -125),
            ylim = c(20, 50)) +
  geom_point(aes(color = urbanicity, size = cases, alpha = cases)) +
  scale_color_viridis_d() +
  scale_size_binned(range = c(0, 8)) +
  NULL

# Total number of cases by urbanicity type over time
covid %>%
  group_by(urbanicity, date) %>%
  summarise(cases = sum(cases)) %>%
  drop_na() %>%
  ggplot(aes(x = date, y = cases, color = urbanicity)) +
  theme_bw() +
  geom_line(size = 1) +
  scale_color_viridis_d() +
  NULL

covid %>%
  group_by(urbanicity, date) %>%
  summarise(cases = sum(cases)) %>%
  drop_na() %>%
  ggplot(aes(x = date, y = cases, color = urbanicity)) +
  theme_bw() +
  geom_line(size = 1) +
  scale_color_viridis_d() +
  labs(title = "Date: {frame_time}") +
  transition_reveal(date) +
  NULL
