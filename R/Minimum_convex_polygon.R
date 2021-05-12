
# Credits -----------------------------------------------------------------

# Code created by Luara Tourinho (https://github.com/luaratourinho)

# 06 May 2021


# First install packages
# Then run the library required

library(maps)
library(mapdata)
library(rgdal)
library(raster)
library(rgeos)



# Some examples of projections --------------------------------------------

# Creating two objects: (1) with the original projection of your data
# and (2) with an equal area projection


# WGS84
crs.wgs84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")

# South America Albers Equal Area Conic
crs.albers <-
  CRS("+proj=aea +lat_1=-5 +lat_2=-42 +lat_0=-32 +lon_0=-60
                  +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs")

# Lambert Azimuthal Equal Area (ideal for Pacific Ocean islands)
crs.azim <-
  CRS("+proj=laea +lat_0=90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84
                +datum=WGS84 +units=m +no_defs")



# Building a minimum convex polygon ---------------------------------------


# Read your table of occurrence records
occurrence_records <-
  read.csv("./mydirectory/my_species_occurrence.csv")

# Check the column names for your coordinates and place below within c("","")
coordinates(occurrence_records) <- c("lon", "lat")

# Define the original projection of your occurrence records
proj4string(occurrence_records) <- crs.wgs84

# Reproject to an equal area projection
occurrence_records_albers <-
  spTransform(occurrence_records, crs.albers)

# Minimum convex polygon (mpc) function
mpc <- gConvexHull(occurrence_records_albers)



# Adding a buffer to the mpc -----------------------------------------------


# You can choose a fixed value for a buffer, for example
# If you want to 500km of ratio, use b = 500000, because b is in meters
# If you want to a proportional value as suggested by Barve et al. 2011
# (doi:10.1016/j.ecolmodel.2011.02.011), use the function gArea.
# The function gArea is in m2, so multipling by 0.000001 you can get a area in km2
# For example, if you want to draw a buffer of 20%, in km, around of the mpc
# 20% of the polygon area is 2e-07
b <- (gArea(mpc) * 2e-07)
buffer_mpc <- gBuffer(mpc, width = b)



# An example of mpc utility -------------------------------------------------


# If you want to clip a worldclim environmental raster
# (https://www.worldclim.org/), which is in WGS84

# Reproject your polygon to the same projection of your environmental data
polygon_wgs <- spTransform(buffer_mpc, crs.wgs84)
plot(polygon_wgs)

# Read your environmental raster
myraster <- raster("D:/mydirectory/myraster.asc")

# Cut your study area for the same extention and shape of your mpc
myraster2 <- crop(myraster, polygon_wgs)
myraster3 <- mask(myraster2, polygon_wgs)

# Plot the results
plot(myraster3)
plot(occurrence_records, add = T)



# Save your layers --------------------------------------------------------


writeOGR(
  polygon_wgs,
  dsn = "D:/mydirectory",
  layer = "polygon_mpc_wgs",
  driver = "ESRI Shapefile",
  overwrite = T)

writeRaster(myraster3,
            "D:/mydirectory/myraster.tif",
            format = "GTiff",
            overwrite = T)
