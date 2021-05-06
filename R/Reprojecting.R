
# Credits -----------------------------------------------------------------

# Code created by Luara Tourinho
# 06 May 2021


# First install packages

install.packages("raster")
install.packages("rgdal")
install.packages("rgeos")

# Library required

library(raster)
library(rgdal)
library(rgeos)



# Some examples of projections --------------------------------------------

# Here, a list of some projections that we can use below to project and 
# reproject spatial objects.
# Pay attention to the original projection of your data and the one that you want.

# WGS84
crs.wgs84_2 <-
  CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")

# Equidistant projection
crs.equi <-
  CRS("+proj=eqc +lat_ts=60 +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# South America Albers Equal Area Conic
crs.albers <-
  CRS("+proj=aea +lat_0=-32 +lon_0=-60 +lat_1=-5 +lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA +datum=WGS84 +units=m +no_defs")

# Lambert Azimuthal Equal Area
crs.azim <- CRS("+proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84
+units=m +no_defs")



# Reprojecting polygon ----------------------------------------------------


# Reading your polygon
mypolygon <- readOGR(dsn="D:/mydirectory", layer="mypolygon") 

# See your polygon
plot(mypolygon)

# Run summary to see the original projection and others information
summary(mypolygon)
# Or just run the object
mypolygon


# Reprojecting your polygon

# First check and set the original projection
proj4string(mypolygon) <- crs.equi

# Then reproject to the chosen projection
mypolygon_albers <- spTransform(mypolygon, crs.albers)

# See and check the informations of your reprojected polygon
plot(mypolygon_albers)
summary(mypolygon_albers)

# Finally, saving your reprojected polygon
writeOGR(mypolygon_albers, dsn = "D:/mydirectory",
         layer = "mypolygon_albers", driver="ESRI Shapefile", overwrite=T)




# Reprojecting rasters ----------------------------------------------------


# Reading your raster
myraster <- raster("D:/mydirectory/myraster.asc")

# See your raster
plot(myraster)

# See the original projection and others information
myraster


# Reprojecting your raster

# First setting the original projection
crs.azim <- CRS("+proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 
                +units=m +no_defs")

proj4string(myraster) <- crs.azim

# Then reproject to the chosen projection
myraster_albers <- projectRaster(myraster, crs=crs.albers)

# See and check the informations of your reprojected raster
plot(myraster_albers)
myraster_albers


# Finally, saving your reprojected raster
writeRaster(myraster_albers, "D:/mydirectory/bio1_albers.tif", format="GTiff",
            overwrite=T)

