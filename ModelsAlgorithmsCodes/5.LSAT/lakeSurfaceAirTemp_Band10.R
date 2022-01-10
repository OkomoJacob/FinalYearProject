# Comprehensive step shown in the article:
# Algorithm for Automated Mapping Using Land Surface Temperature using Landsat 8 satellite data
# Using the six steps:
# Raster, chlorophyll-index and global environment
rm(list = ls(all=TRUE)) #clear memory
library(raster)
library(rgdal)

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.2/0.Project/RESULTS")
path
contents <- length(list.files(path))
contents

# Denote as Multiraster data
aoiRaster <- stack("opticalRasters/2015_02_04_Clip.tif")
Qcal <- stack("TIR Clips/2015_02_04.tif")
ML <- 0.00033420
AL <- 0.10000
Lambda <- 10.8
cTwo = 14388

# Algorithm starts here
## 1. Calculate the TOA spectral Radiance
# E.g If QCal ranges 0 to 2500
TOA = ML*Qcal + AL
# Where:
# ML = Band multiplicative factor in metadata(RADIANCE_MULT_BAND_X))
# Qcal = Band10
# AL = Additive rescaling factor(RADIANCE_ADD_BAND_X)
# E.g TOA = 0.0003342*"Band10.tif" + 0.1
# TOA should now range from 0.1 to 9

## 2. TOA to Brightness Temp(BT) Conversion
KTwo <- 1321.0789
KOne <- 774.8853
BT = ((KTwo/(log(KOne/TOA)+1))-273.15)
# Where:
# K1 = Band Specific thermal conversion constant from metadata(K1_CONSTAANT_BAND_x)
# K2 = Band Specific thermal conversion constant from metadata(K2_CONSTAANT_BAND_x)
# L = TOA

# Example Execution:
# BT = ((1321.6789/(ln(774.8853/"TOA.tif")+1))-273.15)
# BT should now range in between -125 to 22.5

## 3. Calculate Normalized Difference Veg Index - NDVI
# NDVI = (Band5-Band4)/(Band5+Band4)
ndvi <- (aoiRaster[[5]]-aoiRaster[[4]])/(aoiRaster[[5]]+aoiRaster[[4]])
plot(ndvi)

## 4. Calculate Proportion of Vegetation(PV)
PV = ((ndvi+1)/(1+1))^2

# PV can range from 0 to 1
## 5. Calculate Emissivity (E)
E = 0.004 * PV + 0.986
#E should now range between 0.9986 to 0.99

## 6. Calculate the Land Surface Temperature-LST
LST = (BT/(1+(Lambda*BT/cTwo)*log(E)))

plot(E,  main = "2017_03_13")
# Save file on disk
saveFile <- writeRaster(Chl_a, "OC2_13_03_2017.tif", format = "GTiff", datatype = "FLT4S", overwrite = TRUE)


