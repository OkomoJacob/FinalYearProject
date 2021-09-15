/**
1.Import Landsat Datasets 
2.Create a ploygon
3.Exoprt L5 and L8 to Drive using the Export.image.toDrive()
**/

/**1. Datasets Landsat 8 Tier 1 Surface reflectance then open in code editor**/
/**2. Inspect to get the map.setCenter(coordinates and replace, set zoom level to 10)**/
// 3. run to see the whole Dataset covering the whole region
// 4. Create a new geom and create a new clipping funnction

// add this snippet below the dataset
var landsat8 = dataset.median().clip(geometry)
Map.addLayer(landsat8, visParams)
// Modify the date to your requirements then run

/**1. Datasets Landsat 5 Tier 1 Surface reflectance then copy from var cloudMAsk**/

var cloudMask457 = function(image){

}
// upto visParams
