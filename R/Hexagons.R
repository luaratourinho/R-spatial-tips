# Credits -----------------------------------------------------------------

# Code created by 
# Jayme A. Prevedello

# Edited by
# Luara Tourinho

# 11 May 2021


# First install packages
# Then run the library required


# Creating a hexagonal grid using a shapefile -----------------------------



#install.packages('sp', dependencies=TRUE, repos='http://cran.rstudio.com/')
#install.packages('rgeos', dependencies=TRUE, repos='http://cran.rstudio.com/')
#install.packages('raster', dependencies=TRUE, repos='http://cran.rstudio.com/')
#install.packages('rgdal', dependencies=TRUE, repos='http://cran.rstudio.com/')

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

# South_American_Datum_1969
crs.sad69 <-
  CRS("+proj=longlat +ellps=aust_SA +no_defs")

# Albers Equal Area
crs.albers <-
  CRS("+proj=aea +lat_0=-32 +lon_0=-60 +lat_1=-5 +lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA +datum=WGS84 +units=m +no_defs")


# First check and set the original projection
proj4string(mypolygon) <- crs.sad69

# Then reproject to the chosen projection
mypolygon_albers <- spTransform(mypolygon, crs.albers)

mypolygon = mypolygon_albers


# Creating the hexagon sampling in point format to be converted in polygon (in ha)

# Calculating area in m2 and ha
mypolygon$area_m2<-gArea(mypolygon, byid=T)
## 1 ha =~ 233145.9
mypolygon$area_ha<-mypolygon$area_m2/10000

 ## AQUI VC TEM Q ACERTAR O N?MERO DE PONTOS NECESS?RIOS 
# PARA GERAR HEX?GONOS COM A ?REA DESEJADA. VAI TENTANDO
shape_pts <- spsample(mypolygon, n = 11100, type="hexagonal")
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

