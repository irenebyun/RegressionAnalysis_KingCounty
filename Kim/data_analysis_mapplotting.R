install.packages("leaflet")
library(leaflet)

setwd("/Users/DK/Documents/programming/Github/Regression Analysis/rawdata//")
data <- read.csv("kc_house_data.csv", header = TRUE)

# �� ��ġ �浵/���� ����
lati <- data$lat
long <- data$long

# leaflet��Ű���� �̿��Ͽ� ������ map plotting
map <- leaflet() %>% 
    addTiles() %>% 
    addCircleMarkers(lng = long, lat = lati, radius = 0.01, clusterOptions = TRUE) %>% markerClusterOptions(showCoverageOnHover = TRUE, spiderLegPolylineOptions = list(weight = 1.5, color = "#222", opacity = 0.5))