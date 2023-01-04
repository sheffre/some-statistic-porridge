#libs
library(rlist)
library(tidyverse)
library(cowplot)
library(ggspatial)
library(rnaturalearth)
library(sp)
library(sf)
library(RColorBrewer)

#functions definition and metadata creation

true_map <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf") %>%
  st_crop(c(xmin = 60, xmax = 85, ymin = 55, ymax = 78)) %>%
  st_transform(3857)

map_build <- function(x) {
  z <- read.csv(x)
  result <- ggplot() +
            geom_sf(data = true_map, fill = "gray90", 
                    color = "2b2b2b", size = 0.125) +
            coord_sf(lims_method = "geometry_bbox", 
                    default_crs = sf::st_crs(4326)) +
            geom_point(data = z,
                      mapping = aes(as.numeric(E), as.numeric(N)),
                      na.rm = T, size = 0.5, color = "black") +
            labs(x = "Долгота", y = "Широта", 
                 title = paste("Карта станций \nОбской губы за", 
                               z$Y[1], "год", sep = " ")) +
            # xlab("Долгота", size = 14) + ylab("Широта", size = 14) +
            # ggtitle(paste("Карта станций Обской губы \n за", z$Y[1], "год", sep = " "), 
            #         size = 18) +
            theme_bw()
  ggsave(filename = paste(z$Y[1], "png", sep = "."), 
         plot = last_plot(), 
         path = "C:/obskaya_proj_wd/month separation subproject/output/maps/", 
         width = 1500, height = 1500, units = "px", dpi = 300)  
}

#dataset creation & rimming

ob_data <- read.csv("C:/obskaya_proj_wd/database/Archiv_Guba_fin_copy.csv", 
                    header = T)

ob_data <- ob_data[- grep("E", ob_data$E), ]

obskaya_guba_data <- subset(ob_data, 
                            (ob_data$N>=66&ob_data$N<=73)
                            &(ob_data$E>=70&ob_data$E<=75))


write.csv(obskaya_guba_data, file = "C:/obskaya_proj_wd/ready_datasets/ob_rimmed.dat")

#creating paths interface

files <- list.files(path = "C:/obskaya_proj_wd/year_div/csv/",
                    recursive = F)

dirs <- list.dirs(path = "C:/obskaya_proj_wd/month separation subproject/output/tables")
dirs <- dirs[2:46]

output_paths <- vector()
input_paths <- vector()

for (i in 1:length(files)) {
  output_paths[i] <- paste(dirs[i], "csv", sep = ".")
  input_paths[i] <- paste0("C:/obskaya_proj_wd/year_div/csv/", files[i])
}

rm(dirs, i)

#ready dataset filtering

red_files <- list()
red_files <- lapply(input_paths, read.csv)

out_files <- list.filter(red_files, length(Arh_No) > 30)

years_vector <- vector()

mean(out_files[[1]]$Y)

for (i in 1:32) {
  years_vector[i] <- mean(out_files[[i]]$Y) #most genious kostyl in the world
}

for (i in 1:length(years_vector)) {
  write.csv(out_files[[i]], file = 
              paste0("C:/obskaya_proj_wd/month separation subproject/output/out_dir/", 
                     paste(years_vector[i], "csv", sep = ".")))
}

#maps design

input_paths_2 <- vector() 
for (i in 1:length(years_vector)) {
  input_paths_2[i] <- paste0("C:/obskaya_proj_wd/month separation subproject/output/out_dir/", 
                          paste(years_vector[i], "csv", sep = "."))
}

lapply(input_paths_2, map_build)

