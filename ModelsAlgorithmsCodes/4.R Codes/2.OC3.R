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
# R = log_10⁡〖((Rrs(443+Rrs(490),-Rrs(412)))⁄Rrs(555) 〗
# 443 = Coastal,  490 = Blue, 555 = Green 412 = NULL, 

bg_Ratio = (aoiRaster[[1]]+aoiRaster[[2]])-((aoiRaster[[3]])/aoiRaster[[4]])
R = log10(bg_Ratio)

Chl_a = 10^(0.2515-2.3798*R+1.5823*R^2-0.6372*R^3+0.5692*R^4)
# plotRGB(aoiRaster, 4,3,2, scale = 65535, stretch = 'lin')
plot(Chl_a,  main = "06_09_2020")
aoiRaster[16]
# Save file on disk
saveFile <- writeRaster(Chl_a, "06_09_2020.tiff", format = "GTiff", datatype = "FLT4S", overwrite = TRUE)
