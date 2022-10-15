ob_data <- read.csv("C:/obskaya_proj_wd/database/Archiv_Guba_fin_copy.csv", 
                    header = T)

ob_data$fac_M <- factor(ob_data$M)
mon_vector <- c("jan", "feb", "mar", "apr", "may", "jun", "jul",
                "aug", "sep", "oct", "nov", "dec")
descriptor_matrix <- cbind(mon_vector, c(1:12))

for (x in as.integer(descriptor_matrix[, 2])){
  write.csv(ob_data[ob_data$fac_M == x, ], 
            file = paste("C:/obskaya_proj_wd/month_output/", paste(descriptor_matrix[as.integer(x),1], "dat", 
                         sep = ".")))
}
