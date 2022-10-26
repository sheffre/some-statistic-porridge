library(ggplot2)

reg_3_data <- read.csv2(file = "C:/The_Kara_Sea_project/data/region_3.csv")

for(x in levels(as.factor(reg_3_data$Depth))) {
  ggplot(reg_3_data[reg_3_data$factor_horizon == x, ], aes(Year, pH)) +
    geom_line(color = "blue", size = 0.1) +
    geom_point(color = "red") +
    geom_smooth(method = lm, se = F, col = "green", size = 0.5) +
    scale_x_continuous(breaks = seq(min(reg_3_data$Year, na.rm = T), 
                                    max(reg_3_data$Year, na.rm = T),
                                    (max(reg_3_data$Year, na.rm = T) -
                                      min(reg_3_data$Year, na.rm = T))%%10)) +
    scale_y_continuous(breaks = seq(round(min(reg_3_data$pH, na.rm = T), 
                                          digits = 2),
                                    round(max(reg_3_data$pH, na.rm = T),
                                          digits = 2),
                                    round(0.1*(max(reg_3_data$pH, na.rm = T) - 
                                                 min(reg_3_data$pH, na.rm = T)), 
                                          digits = 2)))
  
  ggsave(filename =  paste("C:/The_Kara_Sea_project/output/graph/pH/horizon",
                           paste(x), "jpeg", sep = "."), 
         device = "jpeg", width = 2500, height = 1406, 
         units = "px", dpi = 300)
}

