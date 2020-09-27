library(geojsonio)
library(rgeos)
library(tidyverse)
library(broom)

# Pathing
basepath <- "~/Dropbox (Personal)/Personal Geekery/USA Hex Map/"

# Jiggery pokery to get USA hexmaps
# https://www.r-graph-gallery.com/328-hexbin-map-of-the-usa.html
spdf <- str_c(basepath, "us_states_hexgrid.geojson") %>%
  geojson_read(what = "sp")

spdf@data = spdf@data %>%
  mutate(google_name = gsub(" \\(United States\\)", "", google_name))

spdf_fortified <- tidy(spdf, region = "google_name")

centers <- cbind.data.frame(data.frame(gCentroid(spdf, byid=TRUE), id=spdf@data$iso3166_2))

# Export to CSV
spdf_fortified %>%
  write_csv(str_c(basepath, "hexmap.csv"))

centers %>%
  write_csv(str_c(basepath, "hexmap_labels.csv"))

# Sample plot
spdf_fortified %>%
  ggplot(aes(x = long, y = lat, group = group)) +
  theme_void() +
  coord_map() +
  geom_polygon(color="white") +
  scale_fill_viridis_b(option = "plasma", begin = 0.1, end = 0.8) +
  geom_text(data=centers,
            aes(x = x, y = y, label = id),
            color = "white",
            inherit.aes = FALSE)

