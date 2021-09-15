# Raster, chlorophyll-index and global environment
rm(list = ls(all=TRUE)) #clear memory
library(raster)
library(rgdal)

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.1/0.Project/RESULTS/opticalRasters")
path
contents <- length(list.files(path))
contents

# Denote as Multiraster data
lVictoria <- stack("feb2015Extract.tif")
lVictoria

# CIg = [(NIR / Green)-1]
plotRGB(lVictoria, 4,3,2, scale = 65535, stretch = 'lin')
clg <- (lVictoria[[4]]/lVictoria[[1]]-1)
clg
plot(clg,  main = "Non Bloom")
