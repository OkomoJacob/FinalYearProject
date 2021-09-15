# Raster, chlorophyll-index and global environment
rm(list = ls(all=TRUE)) #clear memory
library(raster)
library(rgdal)

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.1/0.Project/RESULTS/LST")
path
contents <- length(list.files(path))
contents

# Denote as Multiraster data
lVictoriaLST <- stack("L_Vict_2015_LST_Final.tif")
lVictoriaLST

# CIg = [(NIR / Green)-1]
plot(lVictoriaLST,  main = "Bloom, LSWT °C")
