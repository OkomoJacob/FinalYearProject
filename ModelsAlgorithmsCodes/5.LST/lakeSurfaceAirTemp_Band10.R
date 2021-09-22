# Comprehensive step shown in the article:Algorithm for Automated Mapping Using Land Surface Temperature using Landsat 8 satellite data
# Using the six steps:

## 1. Calculate the TOA spectral Radiance
# TOA(L) = ML*Qcal + AL
# Where:
# ML = Band multiplicative factor in metadata
# Qcal = Band10
# AL = Additive rescaling factor
# E.g TOA = 0.0003342*"Band10.tif" + 0.1

## 2. TOA to Brightness Temp(BT) Conversion
# Where:
# BT = ((K2/(ln(K1/L)+1))-273.15)
# 

