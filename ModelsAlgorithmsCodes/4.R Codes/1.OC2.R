# Raster, chlorophyll-index and global environment
rm(list = ls(all=TRUE)) #clear memory
library(raster)
library(rgdal)

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.2/0.Project/RESULTS/opticalRasters")
path
contents <- length(list.files(path))
contents

# Denote as Multiraster data
aoiRaster <- stack("2015_07_30.tif")
aoiRaster

# Algorithm starts here
bg_Ratio = (aoiRaster[[2]]/aoiRaster[[3]])
R = log10(bg_Ratio)

Chl_a = 10^((0.2511-2.0853*R + 1.5035*R^2-3.1747*R^3+0.3383*R^4))*12.4
# plotRGB(aoiRaster, 4,3,2, scale = 65535, stretch = 'lin')
plot(Chl_a,  main = "2017_03_13")
# Save file on disk
saveFile <- writeRaster(Chl_a, "OC2_2015_07_030.tif", format = "GTiff", datatype = "FLT4S", overwrite = TRUE)
