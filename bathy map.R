library(tidyverse)
library(cowplot)
library(ggspatial)
library(rnaturalearth)
library(sp)
library(sf)
library(RColorBrewer)
library(marmap)

ob_data <- read.csv("C:/obskaya_proj_wd/database/Archiv_Guba_fin_copy.csv", 
                    header = T)

ob_data <- ob_data[- grep("E", ob_data$E), ]

# true_map <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf") %>%
#   st_crop(c(xmin = 60, xmax = 85, ymin = 55, ymax = 78)) %>%
#   st_transform(3857)

stations <- data.frame(E = as.numeric(ob_data$E), N = as.numeric(ob_data$N))

non_null_deep <- subset(ob_data, ob_data$Deep != "")
non_null_deep$num_deep <- as.integer(non_null_deep$Deep)
# grid1 <- expand.grid(E = as.numeric(non_null_deep$E), 
#                      N = as.numeric(non_null_deep$N))
# grid1$deep <- non_null_deep$num_deep
# 
# basemap1 <-   ggplot() +
#               geom_sf(data = true_map, fill = "gray90", 
#                       color = "2b2b2b", size = 0.125) +
#               #theme(panel.background = element_blank()) +
#               coord_sf(lims_method = "geometry_bbox", 
#                        default_crs = sf::st_crs(4326)) +
#               geom_point(data = non_null_deep,
#                          mapping = aes(as.numeric(E), 
#                                        as.numeric(N)),
#                          na.rm = T, size = 0.1, color = "black") +
#               theme_bw()
# 
# 
# basemap1

Bathy <- readGEBCO.bathy(file = "C:/obskaya_proj_wd/grids, shapes, et al/GEBCO bathy/Ob/gebco 2/gebco bathy.nc")

data_dots <- subset(non_null_deep, 71 <= non_null_deep$E & non_null_deep$E <= 74)

# autoplot.bathy(bathy1, geom = c("title", "contour")) +
#   scale_fill_gradient2(low="dodgerblue4", 
#                        mid="gainsboro", 
#                        high="darkgreen") +
#   geom_point(data = data_dots,
#              mapping = aes(as.numeric(E), 
#                            as.numeric(N)),
#              na.rm = T, size = 0.1, color = "black") +
#   #coord_cartesian(expand = 0) +
#   ggtitle("A marmap map with ggplot2")

Bathy2 <- as.matrix(bathy1)
class(Bathy2) <- "matrix"
Bathy2 %>%
  as.data.frame() %>%
  rownames_to_column(var = "lon") %>%
  gather(lat, value, -1) %>%
  mutate_all(funs(as.numeric)) %>%
  ggplot()+
  geom_contour_filled(aes(x = lon, y = lat, z = value), 
                      bins = 10) +
  geom_point(data = data_dots,
             mapping = aes(as.numeric(E), 
                           as.numeric(N)),
             na.rm = T, size = 0.5, shape = 6,  color = "black") +
  coord_map()

# blues <- c("lightsteelblue4", "lightsteelblue3", "lightsteelblue2", "lightsteelblue1")
# greys <- c(grey(0.6), grey(0.93), grey(0.99))
# 
# plot(Bathy, image = TRUE, land = TRUE, n=30, lwd = 0.1, 
#      bpal = list(c(0, max(Bathy), greys), c(min(Bathy), 0, blues)), 
#      drawlabels = TRUE)
# plot(Bathy, deep = 0, shallow = 0, step = 0, lwd=2, add = TRUE)
