# Comprehensive step shown in the article:Algorithm for Automated Mapping Using Land Surface Temperature using Landsat 8 satellite data
# Using the six steps:

## 1. Calculate the TOA spectral Radiance
# E.g If QCal ranges 0 to 2500
# TOA(L) = ML*Qcal + AL
# Where:
# ML = Band multiplicative factor in metadata(RADIANCE_MULT_BAND_X))
# Qcal = Band10
# AL = Additive rescaling factor(RADIANCE_ADD_BAND_X)
# E.g TOA = 0.0003342*"Band10.tif" + 0.1
# TOA should now range from 0.1 to 9

## 2. TOA to Brightness Temp(BT) Conversion
# Where:
# BT = ((K2/(ln(K1/L)+1))-273.15)
# Where:
# K1 = Band Specific thermal conversion constant from metadata(K1_CONSTAANT_BAND_x)
# K2 = Band Specific thermal conversion constant from metadata(K2_CONSTAANT_BAND_x)
# L = TOA
# Add Absolute zero(-273.15 to the resultant BT)
# Example Execution:
# BT = ((1321.6789/(ln(774.8853/"TOA.tif")+1))-273.15)
# BT should now range in between -125 to 22.5

## 3. Calculate Normalized Difference Veg Index - NDVI
# NDVI = (Band5-Band4)/(Band5+Band4)
# NDVI Values must range between -1 to +1

## 4. Calculate Proportion of Vegetation(PV)
# PV = ((NDVI-NDVImin)/(NDVImax-NDVImin))^2
# PV = (("NDVI.tif"+1)/(1+1))
# PV can range from 0 to 1

## 5. Calculate Emissivity (E)
# E = 0.004 * PV + 0.986(A correction value in th equation)
# E should now range between 0.9986 to 0.99

## 6. Calculate the Land Surface Temperature-LST
# LST = BT/(1+(Lambda*BT/c2)*Ln(E))
# C2 = 14388um K
# Lambda = 10.8 for L8 OLI_TIR
# LST = (BT/(1+(10.8*BT/1.4388)*ln(E)))
# LST for unclipped should be -125 to 22.5, 
# When you clip out the study area, LST ranges from 9 to 20 deg celcius
# 

