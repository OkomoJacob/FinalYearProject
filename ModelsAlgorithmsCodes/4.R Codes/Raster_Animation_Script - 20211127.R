#A script to animate time series of rasters
#Apply the script for each product that you want to create animations for

#Load libraries
library(raster)
library(rgdal)
library(gdalUtils)
library(rasterVis)
library(animation)
library(classInt)

#set working directory by pasting the path to the console
setwd(readline('Enter path to directory/folder:'))

#Read list of NDVI files
ndvi_files <- list.files(path = getwd(), pattern = ".tif$")

#Load as raster stack
ndvi_stack <- stack(ndvi_files)

#Assign names to the layers with their respective dates or other 
#important information
layernames <- paste0(substring(ndvi_files, 6, 9), " ", "NDVI")

#Set plotting colours and breaks
breaks <- seq(0, 1, by = 0.01)
colors <- colorRampPalette(c("red", "yellow", "green"))(length(breaks) - 1)


#You can also check R Color Brewer to set different color palettes
#See (https://www.r-graph-gallery.com/38-rcolorbrewers-palettes.html)
#Run the lines below to test
#require(RColorBrewer)
#breaks <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8)
#colors <- brewer.pal(11, 'RdYlGn')

#Animate raster stack
#Alter xlim and ylim to fit your plot i.e. control whitespace 
saveGIF({
  for(i in c(1:nlayers(ndvi_stack))){
    l <- levelplot(ndvi_stack[[i]], margin=FALSE, main = layernames[i], 
                   xlim=c(4114500, 4122500), ylim=c(-116500, -124500), at = breaks,
                   col.regions = colors)
    plot(l)
  }
}, interval=0.5, movie.name="NDVI_animation.gif") #use interval to adjust speed, must be factor of 100
