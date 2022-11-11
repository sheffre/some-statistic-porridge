library(tidyverse)
library(cowplot)
library(ggspatial)
library(rnaturalearth)
library(sp)
library(sf)
library(RColorBrewer)

ob_data <- read.csv("C:/obskaya_proj_wd/database/Archiv_Guba_fin_copy.csv", 
                    header = T)

ob_data <- ob_data[- grep("E", ob_data$E), ]

#xmin = 60, xmax = 85, ymin = 60, ymax = 78)

true_map <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf") %>%
    st_crop(c(xmin = 60, xmax = 85, ymin = 55, ymax = 78)) %>%
    st_transform(3857)

stations <- data.frame(E = as.numeric(ob_data$E), N = as.numeric(ob_data$N))

basemap1 <-   ggplot() +
              geom_sf(data = true_map, fill = "gray90", 
                      color = "2b2b2b", size = 0.125) +
              #theme(panel.background = element_blank()) +
              coord_sf(lims_method = "geometry_bbox", 
                       default_crs = sf::st_crs(4326)) +
              geom_point(data = stations,
              mapping = aes(E, N),
              na.rm = T, size = 0.5, color = "black") +
              theme_bw()

basemap1
