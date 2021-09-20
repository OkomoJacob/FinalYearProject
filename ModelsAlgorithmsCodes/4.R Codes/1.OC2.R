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
aoiRaster <- stack("2020_06_09_Lyr_Clip.tif")
aoiRaster

# Algorithm starts here
# Chl-a=10^((0.2511-2.0853R+1.5035R^2-3.1747R^3+0.3383R^4))
# Where R=log_10⁡〖Rrs(490)⁄Rrs(555) 〗
# 490 = Blue, 555 = Green
# ndvi <- (aoiRaster[[5]]-aoiRaster[[4]])/(aoiRaster[[5]]+aoiRaster[[4]])
bg_Ratio = (aoiRaster[[2]]/aoiRaster[[3]])
R = log10(bg_Ratio)

Chl_a = 10^((0.2511-2.0853*R + 1.5035*R^2-3.1747*R^3+0.3383*R^4))
plotRGB(aoiRaster, 4,3,2, scale = 65535, stretch = 'lin')
plot(Chl_a,  main = "06_09_2020")
aoiRaster[16]
# Save file on disk
saveFile <- writeRaster(Chl_a, "06_09_2020.tiff", format = "GTiff", datatype = "FLT4S", overwrite = TRUE)
