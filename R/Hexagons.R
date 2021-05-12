
# Credits -----------------------------------------------------------------

# Code got by a set of routines, such as
# Jayme A. Prevedello
# https://gist.github.com/rafapereirabr/e1b73de3b019f4623af09f7d8c697c79

# Edited by
# Luara Tourinho (https://github.com/luaratourinho)

# 11 May 2021


# Creating a hexagonal grid using a shapefile -----------------------------

# 2 options to creating a hexagonal grid ----------------------------------


# Library required
library(sp)
library(rgeos)
library(raster)
library(rgdal)

# Select a shapefile on which you want to build a hexagonal grid
mypolygon <- shapefile("C:/mydirectory/mypolygon.shp")

# or use this function to open your polygon
mypolygon <- readOGR(dsn="C:/mydirectory", layer="mypolygon")

plot(mypolygon)

# Reproject the shapefile for a planar projection, i.e., in meters
# See "Reprojecting.R" to learn better how to reproject spatial objects

# Examples

# South_American_Datum_1969 (geographic projection)
crs.sad69 <-
  CRS("+proj=longlat +ellps=aust_SA +no_defs")

# UTM (planar projection)
crs.utm <- 
  CRS("+proj=utm +zone=33 +ellps=GRS80 +units=m +no_defs")

# Albers Equal Area (planar projection)
crs.albers <-
  CRS("+proj=aea +lat_0=-32 +lon_0=-60 +lat_1=-5 +lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA +datum=WGS84 +units=m +no_defs")


# First check and set the original projection
proj4string(mypolygon) <- crs.sad69

# Then reproject to the chosen projection
mypolygon_albers <- spTransform(mypolygon, crs.albers)

mypolygon = mypolygon_albers



# First option ------------------------------------------------------------


# Creating the hexagon sampling in point format to be converted in polygon (in ha)

# Calculating area in m2 and ha
mypolygon$area_m2<-gArea(mypolygon, byid=T)
mypolygon$area_ha<-mypolygon$area_m2/10000


# Here you have to define the number of points needed to generate the 
# hexagons with the desired area. Keep trying, like a sensitivity analysis
shape_pts <- spsample(mypolygon, n = 11100, type = "hexagonal")
plot(shape_pts)

# Converting the points created to hexagonal polygons
HexPols <- HexPoints2SpatialPolygons(shape_pts)
plot(HexPols)

# Calculating the area of the hexagon
HexPols$area_m2<-gArea(HexPols, byid=T)
HexPols$area_ha<-HexPols$area_m2/10000

# Polygon area, in hectares
# Getting a information from a polygon
HexPols$area_ha[1] 
length(HexPols$area_ha)

plot(mypolygon)
plot(HexPols, add=T)

# Saving your reprojected polygon

writeOGR(HexPols, dsn = "D:/mydirectory",
         layer = "hexagons", driver="ESRI Shapefile", overwrite=T)

# Or using this function

shapefile(HexPols,"D:/mydirectory/hexagons")




# Second option -----------------------------------------------------------


# Creating hexagonal grid by a defined area -------------------------------


# Function got in https://gist.github.com/rafapereirabr/e1b73de3b019f4623af09f7d8c697c79
# rafapereirabr/Create Hexagonal grid.R

###### 2 Function to create hexagonal grid -----------

HexGrid <- function(mycellsize, originlpolygon) { 
  
  # Define size of hexagon bins in meters to create points
  HexPts <- spsample(originlpolygon, type="hexagonal", offset=c(0,0), cellsize=mycellsize)
  
  # Create Grid - transform into spatial polygons
  HexPols <- HexPoints2SpatialPolygons(HexPts)
  
  # convert to spatial polygon data frame
  df <- data.frame(idhex = getSpPPolygonsIDSlots(HexPols))
  row.names(df) <- getSpPPolygonsIDSlots(HexPols)
  hexgrid <- SpatialPolygonsDataFrame(HexPols, data =df)
  return(hexgrid)
}

###### 3: Create Hexagonal grid -------------------

# 50000 (five thousand) meters
HexPols <- HexGrid(50000, mypolygon)
plot(HexPols)

