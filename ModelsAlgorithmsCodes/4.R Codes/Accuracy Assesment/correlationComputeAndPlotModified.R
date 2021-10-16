#This script show to compare two satellite images, from the same platform (in this case Sentinel-2)
#You compare two bands, before processing and after processing
#The images have been preprocessed using QGIS Semi-automatic classification plugin,
#From DN to TOA
##==========================================================================================##
#Load installed libraries
library(raster)
library(rgdal)
library(gdalUtils)
library(RStoolbox)
library(ggplot2)

##==========================================================================================##
#Set the working directory containing hdf files
#Working directory for this script is E:/PROPOSAL/201808_Report/Fusion-LC8 NDVI comparison
#Ask user to give path to directory 
directory <- readline('Enter Path to Directory You want to set as default:\n (use backslash e.g. "E:/MyDirectory"): ')

#Set the working directory
myfunction <- function(directory) 
{
  if (!is.null(directory))
    setwd(directory)
}
myfunction(directory)

#Print the current
getwd()
##******************************************************************************************##
                            #Convert the Sentinel-2 .jp2 to .tif#
##******************************************************************************************##
s2_bands <- list.files(path = getwd(), pattern = ".jp2")
new_filenames <- paste0("S2_preprocessing", substr(s2_bands, 35,38),'.tif')
for (i in 1:length(s2_bands)) {
  gdalUtilities::gdal_translate(s2_bands, new_filenames[i])
}
##******************************************************************************************##
        #Load Bands 2 - 5 images (.tif) i.e. before and after processing#
##******************************************************************************************##
##Band 2 Plot
#Sentinel-2 Band 2 preprocessing image
s2b2_file_prepro <- list.files(path = getwd(), pattern = "S2_preprocessing_B02.tif")
s2b2_img_prepro <- raster(s2b2_file_prepro)

#Sentinel-2 Band 2 postprocessing image
s2b2_file_postpro <- list.files(path = getwd(), pattern = "RT_L1C_T36MZE_A019437_20190313T080640_B02.tif")
s2b2_img_postpro <- raster(s2b2_file_postpro)
#Ensure that images are of the same extent
extent(s2b2_img_prepro) <- extent(s2b2_img_postpro)
#Create image stacks
s2b2_stack <- stack(s2b2_img_prepro, s2b2_img_postpro)

#Create matrix of a random sample of pixels from the two images
s2_sample <- data.frame(sampleRandom(s2b2_stack, size = 10000))
#Scatter plot colored by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- s2_sample$S2_preprocessing_B02
y <- s2_sample$RT_L1C_T36MZE_A019437_20190313T080640_B02
label <- paste("italic(R)^2 == ", round(cor(s2_sample$S2_preprocessing_B02, s2_sample$RT_L1C_T36MZE_A019437_20190313T080640_B02), 4))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Preprocessing Sentinel-2 Band 2", y = "Postprocessing Sentinel-2 Band 2", 
       title = "Scatter plot of Pre- and Post-Processed Serntinel 2 Band 2") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = 2000, y = 0.4, label = label, size = 6, colour = "black", parse = TRUE)
print(p)

# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Create matrix of a random sample of pixels from the fusion and cloud masked Landsat NDVI layers
lc8_fusion_masked.sample <- data.frame(sampleRandom(fusion_lc8masked.stack, size = 100000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion_masked.sample$LC8_20160418_NDVI_Chiba_masked
y <- lc8_fusion_masked.sample$Chiba_NDVI_2016109_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion_masked.sample$LC8_20160418_NDVI_Chiba_masked, 
                                            lc8_fusion_masked.sample$Chiba_NDVI_2016109_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Cloud-masked Landsat Image - 18th April 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
##==========================================================================================##
##==========================================================================================##
##May 2016 04 plot
#Landsat NDVI unmasked image
LC8_125_file <- list.files(path = getwd(), pattern = "LC8_20160504_NDVI.tif")
LC8_125_img <- raster(LC8_125_file)
#Landsat NDVI cloud masked image
LC8_125masked_file <- list.files(path = getwd(), pattern = "LC8_20160504_NDVI_Chiba_masked.tif")
LC8_125masked_img <- raster(LC8_125masked_file)
#MODIS-Landsat NDVI fusion image
fusion_125_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2016125_30m_ESTARFM.tif")
fusion_125_img <- raster(fusion_125_file)
#Ensure that images are of the same extent
extent(LC8_125_img) <- extent(fusion_125_img)
extent(LC8_125masked_img) <- extent(fusion_125_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_125_img, fusion_125_img)
fusion_lc8masked.stack <- stack(LC8_125masked_img, fusion_125_img)

#Create matrix of a random sample of pixels from the fusion and Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 100000))
#Scatter plot coloured by density
x <- lc8_fusion.sample$LC8_20160504_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2016125_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20160504_NDVI, lc8_fusion.sample$Chiba_NDVI_2016125_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 4th May 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Create matrix of a random sample of pixels from the fusion and cloud masked Landsat NDVI layers
lc8_fusion_masked.sample <- data.frame(sampleRandom(fusion_lc8masked.stack, size = 100000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion_masked.sample$LC8_20160504_NDVI_Chiba_masked
y <- lc8_fusion_masked.sample$Chiba_NDVI_2016125_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion_masked.sample$LC8_20160504_NDVI_Chiba_masked, 
                                            lc8_fusion_masked.sample$Chiba_NDVI_2016125_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Cloud-masked Landsat Image - 4th May 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
##==========================================================================================##
##==========================================================================================##
##July 2016 07 plot
#Landsat NDVI unmasked image
LC8_189_file <- list.files(path = getwd(), pattern = "LC8_20160707_NDVI.tif")
LC8_189_img <- raster(LC8_189_file)
#Landsat NDVI cloud masked image
LC8_189masked_file <- list.files(path = getwd(), pattern = "LC8_20160707_NDVI_Chiba_masked.tif")
LC8_189masked_img <- raster(LC8_189masked_file)
#MODIS-Landsat NDVI fusion image
fusion_189_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2016189_30m_ESTARFM.tif")
fusion_189_img <- raster(fusion_189_file)
#Ensure that images are of the same extent
extent(LC8_189_img) <- extent(fusion_189_img)
extent(LC8_189masked_img) <- extent(fusion_189_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_189_img, fusion_189_img)
fusion_lc8masked.stack <- stack(LC8_189masked_img, fusion_189_img)

#Create matrix of a random sample of pixels from the fusion and Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 100000))

#Scatter plot coloured by density
x <- lc8_fusion.sample$LC8_20160707_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2016189_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20160707_NDVI, lc8_fusion.sample$Chiba_NDVI_2016189_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 7th July 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Create matrix of a random sample of pixels from the fusion and cloud masked Landsat NDVI layers
lc8_fusion_masked.sample <- data.frame(sampleRandom(fusion_lc8masked.stack, size = 100000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion_masked.sample$LC8_20160707_NDVI_Chiba_masked
y <- lc8_fusion_masked.sample$Chiba_NDVI_2016189_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion_masked.sample$LC8_20160707_NDVI_Chiba_masked, 
                                            lc8_fusion_masked.sample$Chiba_NDVI_2016189_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Cloud-masked Landsat Image - 7th July 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = 0.005, y = 0.81, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
##==========================================================================================##
##==========================================================================================##
##December 2016 30 plot
#Landsat NDVI unmasked image
LC8_365_file <- list.files(path = getwd(), pattern = "LC8_20161230_NDVI.tif$")
LC8_365_img <- raster(LC8_365_file)

#MODIS-Landsat NDVI fusion image
fusion_365_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2016365_30m_ESTARFM.tif$")
fusion_365_img <- raster(fusion_365_file)

#Ensure that images are of the same extent
extent(LC8_365_img) <- extent(fusion_365_img)

#Create image stacks
fusion_lc8.stack <- stack(LC8_365_img, fusion_365_img)

#Create matrix of a random sample of pixels from the fusion and Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 100000))
#Scatter plot coloured by density
x <- lc8_fusion.sample$LC8_20161230_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2016365_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20161230_NDVI, lc8_fusion.sample$Chiba_NDVI_2016365_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  xlim(-0.75,1) +
  ylim(-0.75,1) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 30th December 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.55, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Create matrix of a random sample of pixels from the fusion and cloud masked Landsat NDVI layers
lc8_fusion_masked.sample <- data.frame(sampleRandom(fusion_lc8masked.stack, size = 100000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion_masked.sample$LC8_20161230_NDVI_Chiba_masked
y <- lc8_fusion_masked.sample$Chiba_NDVI_2016365_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion_masked.sample$LC8_20161230_NDVI_Chiba_masked, 
                                            lc8_fusion_masked.sample$Chiba_NDVI_2016365_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Cloud-masked Landsat Image - 30th December 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.45, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
##******************************************************************************************##
                                        #2017 Start#
##******************************************************************************************##
##==========================================================================================##
##January 2017 31 plot
#Landsat NDVI unmasked image
LC8_031_file <- list.files(path = getwd(), pattern = "LC8_20170131_NDVI.tif$")
LC8_031_img <- raster(LC8_031_file)
#Landsat NDVI cloud masked image
LC8_031masked_file <- list.files(path = getwd(), pattern = "LC8_20170131_NDVI_Chiba_masked.tif$")
LC8_031masked_img <- raster(LC8_031masked_file)
#MODIS-Landsat NDVI fusion image
fusion_031_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2017031_30m_ESTARFM.tif")
fusion_031_img <- raster(fusion_031_file)
#Ensure that images are of the same extent
extent(LC8_031_img) <- extent(fusion_031_img)
extent(LC8_031masked_img) <- extent(fusion_031_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_031_img, fusion_031_img)
fusion_lc8masked.stack <- stack(LC8_031masked_img, fusion_031_img)

#Create matrix of a random sample of pixels from the fusion and Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 100000))

#Scatter plot coloured by density
x <- lc8_fusion.sample$LC8_20170131_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2017031_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20170131_NDVI, lc8_fusion.sample$Chiba_NDVI_2017031_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 31st January 2017") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.3, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Create matrix of a random sample of pixels from the fusion and cloud masked Landsat NDVI layers
lc8_fusion_masked.sample <- data.frame(sampleRandom(fusion_lc8masked.stack, size = 100000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion_masked.sample$LC8_20170131_NDVI_Chiba_masked
y <- lc8_fusion_masked.sample$Chiba_NDVI_2017031_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion_masked.sample$LC8_20170131_NDVI_Chiba_masked, 
                                            lc8_fusion_masked.sample$Chiba_NDVI_2017031_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Cloud-masked Landsat Image - 31st January 2017") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.3, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)

##==========================================================================================##
##March 2017 20 plot
#Landsat NDVI unmasked image
LC8_079_file <- list.files(path = getwd(), pattern = "LC8_20170320_NDVI.tif$")
LC8_079_img <- raster(LC8_079_file)
#MODIS-Landsat NDVI fusion image
fusion_079_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2017079_30m_ESTARFM.tif")
fusion_079_img <- raster(fusion_079_file)
#Ensure that images are of the same extent
extent(LC8_079_img) <- extent(fusion_079_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_079_img, fusion_079_img)

#Create matrix of a random sample of pixels from the fusion and Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 100000))

#Scatter plot coloured by density
x <- lc8_fusion.sample$LC8_20170320_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2017079_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20170320_NDVI, lc8_fusion.sample$Chiba_NDVI_2017079_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 20th March 2017") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
##******************************************************************************************##
                                          #2015 Start#
##******************************************************************************************##
##===========================================================================================##
##March 2015 31 plot
#Landsat NDVI unmasked image
LC8_090_file <- list.files(path = getwd(), pattern = "LC8_20150331_NDVI.tif$")
LC8_090_img <- raster(LC8_090_file)
#MODIS-Landsat NDVI fusion image
fusion_090_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015090_30m_ESTARFM.tif$")
fusion_090_img <- raster(fusion_090_file)
#Ensure that images are of the same extent
extent(LC8_090_img) <- extent(fusion_090_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_090_img, fusion_090_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 500000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20150331_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2015090_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20150331_NDVI, lc8_fusion.sample$Chiba_NDVI_2015090_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 31st March 2015") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
p <- p + expand_limits(x = -1, y = -1)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Hexbin plot with legend
p <- ggplot(df) + geom_hex(aes(x, y), bins = 100) +
  scale_fill_gradientn("legend", colours = rev(rainbow(10, end = 4/6))) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 31st March 2015") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
p <- p + expand_limits(x = -1, y = -1)
print(p)

##===========================================================================================##
##May 2015 02 plot
#Landsat NDVI unmasked image
LC8_122_file <- list.files(path = getwd(), pattern = "LC8_20150502_NDVI.tif$")
LC8_122_img <- raster(LC8_122_file)
#MODIS-Landsat NDVI fusion image
fusion_122_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015122_30m_ESTARFM.tif$")
fusion_122_img <- raster(fusion_122_file)
#Ensure that images are of the same extent
extent(LC8_122_img) <- extent(fusion_122_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_122_img, fusion_122_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 500000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20150502_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2015122_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20150502_NDVI, lc8_fusion.sample$Chiba_NDVI_2015122_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1, intercept =  0, slope = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 2nd May 2015") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.15, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
p <- p + expand_limits(x = -1, y = -1)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

##===========================================================================================##
##April 2015 16 plot
#Landsat NDVI unmasked image
LC8_106_file <- list.files(path = getwd(), pattern = "LC8_20150416_NDVI.tif$")
LC8_106_img <- raster(LC8_106_file)
#MODIS-Landsat NDVI fusion image
fusion_106_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015106_30m_ESTARFM.tif$")
fusion_106_img <- raster(fusion_106_file)
#Ensure that images are of the same extent
extent(LC8_106_img) <- extent(fusion_106_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_106_img, fusion_106_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 1000000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20150416_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2015106_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20150416_NDVI, lc8_fusion.sample$Chiba_NDVI_2015106_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  coord_cartesian(xlim = c(-1, 1), ylim = c(-1,1))+
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 24, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 24, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "16th April 2015") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.75, y = 0.84, label = label, size = 10, colour = "black", parse = TRUE)
p <- p + expand_limits(x = -1, y = -1)
print(p)

# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Hexbin plot with legend
p <- ggplot(df) + 
  geom_hex(aes(x, y), bins = 800, show.legend = TRUE) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0,1)) +
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 18, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 18, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  scale_fill_gradientn(colours = rev(rainbow(10, end = 4/6))) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Observed Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "(b) 16th April 2015") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 0.12, y = 0.92, label = label, size = 10, colour = "black", parse = TRUE)
   
print(p)

##===========================================================================================##
##October 2015 9 plot
#Landsat NDVI unmasked image
LC8_282_file <- list.files(path = getwd(), pattern = "LC8_20151009_NDVI.tif$")
LC8_282_img <- raster(LC8_282_file)
#MODIS-Landsat NDVI fusion image
fusion_282_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015282_30m_ESTARFM.tif$")
fusion_282_img <- raster(fusion_282_file)
#Ensure that images are of the same extent
extent(LC8_282_img) <- extent(fusion_282_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_282_img, fusion_282_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 1000000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20151009_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2015282_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20151009_NDVI, lc8_fusion.sample$Chiba_NDVI_2015282_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  coord_cartesian(xlim = c(-1, 1))+
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 24, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 24, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Observed Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "9th October 2015") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.75, y = 0.84, label = label, size = 10, colour = "black", parse = TRUE)
p <- p + expand_limits(x = -1, y = -1)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Hexbin plot with legend
p <- ggplot(df) + 
  geom_hex(aes(x, y), bins = 800, show.legend = TRUE) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0,1)) +
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 18, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 18, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  scale_fill_gradientn(colours = rev(rainbow(10, end = 4/6))) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Observed Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "(c) 9th October 2015") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 0.12, y = 0.92, label = label, size = 10, colour = "black", parse = TRUE)

print(p)

##===========================================================================================##
##October 2015 25 plot
#Landsat NDVI unmasked image
LC8_298_file <- list.files(path = getwd(), pattern = "LC8_20151025_NDVI.tif$")
LC8_298_img <- raster(LC8_298_file)
#MODIS-Landsat NDVI fusion image
fusion_298_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015298_30m_ESTARFM.tif$")
fusion_298_img <- raster(fusion_298_file)
#Ensure that images are of the same extent
extent(LC8_298_img) <- extent(fusion_298_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_298_img, fusion_298_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 1000000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20151025_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2015298_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20151025_NDVI, lc8_fusion.sample$Chiba_NDVI_2015298_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  coord_cartesian(xlim = c(-1, 1))+
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 24, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 24, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "25th October 2015") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.75, y = 0.84, label = label, size = 10, colour = "black", parse = TRUE)
p <- p + expand_limits(x = -1, y = -1)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Hexbin plot with legend
p <- ggplot(df) + 
  geom_hex(aes(x, y), bins = 800, show.legend = TRUE) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0,1)) +
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 18, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 18, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  scale_fill_gradientn(colours = rev(rainbow(10, end = 4/6))) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Observed Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "(d) 25th October 2015") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 0.12, y = 0.92, label = label, size = 10, colour = "black", parse = TRUE)

print(p)

##===========================================================================================##
##January 2015 10 plot
#Landsat NDVI unmasked image
LC8_010_file <- list.files(path = getwd(), pattern = "LC8_20150110_NDVI.tif$")
LC8_010_img <- raster(LC8_010_file)
#MODIS-Landsat NDVI fusion image
fusion_010_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015010_30m_ESTARFM.tif$")
fusion_010_img <- raster(fusion_010_file)
#Ensure that images are of the same extent
extent(LC8_010_img) <- extent(fusion_010_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_010_img, fusion_010_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 1000000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20150110_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2015010_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20150110_NDVI, lc8_fusion.sample$Chiba_NDVI_2015010_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
df <- df[!(x >= 1 & x <= -1),]
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  coord_cartesian(xlim = c(-1, 1))+
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 24, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 24, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "10th January 2015") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = -0.75, y = 0.84, label = label, size = 10, colour = "black", parse = TRUE)
p <- p + expand_limits(x = -1, y = -1)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

#Hexbin plot with legend
p <- ggplot(df) + 
  geom_hex(aes(x, y), bins = 800, show.legend = TRUE) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0,1)) +
  theme(plot.title = element_text(size = 24, face ="bold"),
        axis.title = element_text(size = 24, face = "bold"),
        axis.text.x = element_text(size = 18, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 18, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  scale_fill_gradientn(colours = rev(rainbow(10, end = 4/6))) + 
  geom_abline(lwd = 1, intercept = 0, slope = 1) +
  labs(x = "Observed Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "(a) 10th January 2015") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 0.12, y = 0.92, label = label, size = 10, colour = "black", parse = TRUE)

print(p)

##===========================================================================================##
##March 2016 17 plot
#Landsat NDVI unmasked image
LC8_077_file <- list.files(path = getwd(), pattern = "LC8_20160317_NDVI.tif$")
LC8_077_img <- raster(LC8_077_file)
#MODIS-Landsat NDVI fusion image
fusion_077_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2016077_30m_ESTARFM.tif$")
fusion_077_img <- raster(fusion_077_file)
#Ensure that images are of the same extent
extent(LC8_077_img) <- extent(fusion_077_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_077_img, fusion_077_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 200000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20160317_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2016077_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20160317_NDVI, lc8_fusion.sample$Chiba_NDVI_2016077_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  xlim(-1.0, 1.0) + #Set the range of x values to between -0.5 and 1 in order to center the plot
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 17th March 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.75, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

##===========================================================================================##
##April 2016 18 plot
#Landsat NDVI unmasked image
LC8_109_file <- list.files(path = getwd(), pattern = "LC8_20160418_NDVI.tif$")
LC8_109_img <- raster(LC8_109_file)
#MODIS-Landsat NDVI fusion image
fusion_109_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2016109_30m_ESTARFM.tif$")
fusion_109_img <- raster(fusion_109_file)
#Ensure that images are of the same extent
extent(LC8_109_img) <- extent(fusion_109_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_109_img, fusion_109_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 200000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20160418_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2016109_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20160418_NDVI, lc8_fusion.sample$Chiba_NDVI_2016109_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  xlim(-0.75, 1.0) + #Set the range of x values to between -0.5 and 1 in order to center the plot
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 18th April 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.5, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

##===========================================================================================##
##May 2016 04 plot
#Landsat NDVI unmasked image
LC8_125_file <- list.files(path = getwd(), pattern = "LC8_20160504_NDVI.tif$")
LC8_125_img <- raster(LC8_125_file)
#MODIS-Landsat NDVI fusion image
fusion_125_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2016125_30m_ESTARFM.tif$")
fusion_125_img <- raster(fusion_125_file)
#Ensure that images are of the same extent
extent(LC8_125_img) <- extent(fusion_125_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_125_img, fusion_125_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 200000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20160504_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2016125_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20160504_NDVI, lc8_fusion.sample$Chiba_NDVI_2016125_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  xlim(-0.75, 1.0) + #Set the range of x values to between -0.5 and 1 in order to center the plot
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 4th May 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.5, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

##===========================================================================================##
##October 2016 27 plot
#Landsat NDVI unmasked image
LC8_301_file <- list.files(path = getwd(), pattern = "LC8_20161027_NDVI.tif$")
LC8_301_img <- raster(LC8_301_file)
#MODIS-Landsat NDVI fusion image
fusion_301_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2016301_30m_ESTARFM.tif$")
fusion_301_img <- raster(fusion_301_file)
#Ensure that images are of the same extent
extent(LC8_301_img) <- extent(fusion_301_img)
#Create image stacks
fusion_lc8.stack <- stack(LC8_301_img, fusion_301_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_lc8.stack, size = 200000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$LC8_20161027_NDVI
y <- lc8_fusion.sample$Chiba_NDVI_2016301_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$LC8_20161027_NDVI, lc8_fusion.sample$Chiba_NDVI_2016301_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  xlim(-0.5, 1.0) + #Set the range of x values to between -0.5 and 1 in order to center the plot
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "Landsat NDVI", y = "ESTARFM_Fusion NDVI", 
       title = "Scatter plot of Fusion NDVI result and Original Landsat Image - 27th October 2016") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.25, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient

##===========================================================================================##
##Comparison of two consecutive fusion images
#First fusion image of 2015 (20150110)
fusion_010_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015010_30m_ESTARFM.tif$")
fusion_010_img <- raster(fusion_010_file)
#Second fusion image of 2015 after 8 days (20150118)
fusion_018_file <- list.files(path = getwd(), pattern = "Chiba_NDVI_2015018_30m_ESTARFM.tif$")
fusion_018_img <- raster(fusion_018_file)
#Ensure that images are of the same extent
#extent(LC8_125_img) <- extent(fusion_125_img)
#Create image stacks
fusion_stack <- stack(fusion_010_img, fusion_018_img)

#Create matrix of a random sample of pixels from the fusion and non-cloud masked Landsat NDVI layers
lc8_fusion.sample <- data.frame(sampleRandom(fusion_stack, size = 200000))
#Scatter plot coloured by density between MODIS-fusion and non-cloud masked Landsat NDVI
x <- lc8_fusion.sample$Chiba_NDVI_2015010_30m_ESTARFM
y <- lc8_fusion.sample$Chiba_NDVI_2015018_30m_ESTARFM
label <- paste("italic(R)^2 == ", round(cor(lc8_fusion.sample$Chiba_NDVI_2015010_30m_ESTARFM, lc8_fusion.sample$Chiba_NDVI_2015018_30m_ESTARFM), 2))
df <- data.frame(x = x, y = y,
                 d = densCols(x, y, colramp = colorRampPalette(rev(rainbow(10, end = 4/6)))))
p <- ggplot(df) +
  geom_point(aes(x, y, col = d), size = 1) + 
  xlim(-0.75, 1.0) + #Set the range of x values to between -0.5 and 1 in order to center the plot
  theme(plot.title = element_text(size = 16, face ="bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 14, face = "bold", color = "blue"),
        axis.text.y = element_text(size = 14, face = "bold", color = "blue"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "mm")) + 
  geom_abline(lwd = 1) +
  labs(x = "ESTARFM Fusion 20150110 NDVI", y = "ESTARFM Fusion 20150118 NDVI", 
       title = "Scatter plot of two consecutive Fusion images") + 
  scale_color_identity() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  annotate("text", x = - 0.5, y = 0.8, label = label, size = 6, colour = "black", parse = TRUE)
print(p)
# Can also use --> p + annotate("text", x = 4, y = 25, label = "italic(R) ^ 2 == 0.75", parse = TRUE)
#for annotation of correlation coefficient
