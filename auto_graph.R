reg_3_data <- read.csv2(file = "C:/The_Kara_Sea_project/data/region_3.csv")

reg_3_data$factor_horizon <- as.factor(reg_3_data$Depth)

for(x in levels(reg_3_data$factor_horizon)) {
  ggplot(reg_3_data[reg_3_data$factor_horizon == x, ], aes(Year, Omega_Ar)) +
    geom_line(color = "blue", size = 0.1) +
    geom_point(color = "red") +
    geom_smooth(method = lm, se = F, col = "green", size = 0.5) +
    scale_x_continuous(breaks = seq(1936, 2022, 4)) +
    scale_y_continuous(breaks = seq(1, 14, 0.05))
  
  ggsave(filename =  paste("C:/The_Kara_Sea_project/output/graph/omega_Ar/horizon",
                           paste(x), "jpeg", sep = "."), 
         device = "jpeg", width = 2500, height = 1406, 
         units = "px", dpi = 300)
}
