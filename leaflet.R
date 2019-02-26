# install.packages(c("ggplot2", "dplyr", "geojsonio"))
library(leaflet)
library(dplyr)


# Basic leaflet usage ----

# leaflet()     Starts a map
# addTiles()    Add basemap so you can se eenvironment
# addMarkers()  Add a marker at a position
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = -122.30768, lat = 47.65486, popup = "Mary Gates Hall")

# setView()     Set center and zoom of map
leaflet() %>% 
  addTiles() %>% 
  setView(lng = -122.30768, lat = 47.65486, zoom = 10)


# Example: Leaflet with UW Data ----

uw_landmarks <- data.frame(
  lng = c(
    -122.30768, -122.30992, -122.31500
  ),
  lat = c(
    47.65486, 47.65584, 47.65246
  ),
  name = c(
    "Mary Gates Hall", "Brick Monoliths", "Fisheries"
  ),
  minutes_away = c(
    0, 5, 20
  ),
  stringsAsFactors = F
)

leaflet() %>%
  addTiles() %>%
  addMarkers(lng = uw_landmarks$lng, lat = uw_landmarks$lat,
             popup = uw_landmarks$name)

# tilde character can be considered as "evaluate this variable
# in the context of the data we're using." Similar to when you
# use dplyr, except with leaflet, you have to explicitly include
# tilde.
leaflet(uw_landmarks) %>%
  addTiles() %>%
  addMarkers(lng = ~lng, lat = ~lat,
             popup = ~name)

leaflet(data = uw_landmarks) %>%
  addTiles() %>%
  addCircleMarkers(lng = ~lng, lat = ~lat,
                   radius = ~minutes_away,
                   popup = ~name)

# colorNumeric  Creates color palette given a set of colors and a domain
distance_pal <- colorNumeric(
  palette = c("green", "red"),
  domain = uw_landmarks$minutes_away
)
leaflet(data = uw_landmarks) %>%
  addTiles() %>%
  addCircleMarkers(lng = ~lng, lat = ~lat,
                   color = ~distance_pal(minutes_away),
                   popup = ~name)


# Example: Leaflet Choropleth of State Density

library(geojsonio)
states <- geojson_read("us-states.geojson", what = "sp")

dens_pal <- colorNumeric(palette = "Reds", domain = states$density)

leaflet(states) %>%
  addTiles() %>% 
  addPolygons(
    fillColor = ~dens_pal(density),
    weight = 0,
    popup = ~paste0(name, ": ", density, " people per square mile")
  )

# That's pretty pale... why??

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
dens_pal <- colorBin(palette = "Reds", domain = states$density, bins = bins)

leaflet(states) %>%
  addTiles() %>% 
  addPolygons(
    fillColor = ~dens_pal(density),
    weight = 0,
    popup = ~paste0(name, ": ", density, " people per square mile")
  )
