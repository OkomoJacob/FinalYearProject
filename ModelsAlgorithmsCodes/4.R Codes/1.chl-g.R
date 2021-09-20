# Raster, chlorophyll-index and global environment
rm(list = ls(all=TRUE)) #clear memory
library(raster)
library(rgdal)

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.2/0.Project/RESULTS/Optical ERDAS")
path
contents <- length(list.files(path))
contents

# Denote as Multiraster data

aoiRaster <- stack()"L8NgaraAOI/NgaraAOI.tif"
aoiRaster

# Aalgorithm starts here
plotRGB(aoiRaster, 4,3,2, scale = 65535, stretch = 'lin')
ndvi <- (aoiRaster[[5]]-aoiRaster[[4]])/(aoiRaster[[5]]+aoiRaster[[4]])
ndvi
plot(ndvi,  main = "NGARA NDVI RAW")

# Save file on disk
saveFile <- writeRaster(ndvi, "ngaraNDVI.tiff", format = "GTiff", datatype = "FLT4S", overwrite = TRUE)