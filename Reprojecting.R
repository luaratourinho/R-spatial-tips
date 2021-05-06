# install.packages("raster")

library(raster)
library(rgdal)
library(rgeos)


# Reading my polygon
mypolygon <- readOGR(dsn="D:/Luara Tourinho/OneDrive/Documentos/Aulas/SIG, paisagem e modelagem/Atividades e dados/A4 - roteiro 2", 
                     layer="MAtl_Ecoregion") 
plot(mypolygon)
# run summary to see the original projection
summary(mypolygon)


# Equidistant projection - exemplo: projecao original
crs.equi <-
  CRS("+proj=eqc +lat_ts=60 +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# South America Albers Equal Area Conic - exemplo projecao quero
crs.albers <-
  CRS("+proj=aea +lat_0=-32 +lon_0=-60 +lat_1=-5 +lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA +datum=WGS84 +units=m +no_defs")

# Reprojecting polygons


# First setting the original projection
proj4string(mypolygon) <- crs.equi

# Then reproject to the chosen projection
mypolygon_albers <- spTransform(mypolygon, crs.albers)
plot(mypolygon_albers)
summary(mypolygon_albers)


# Reprojecting rasters

# Reading my raster
myraster <- raster("./Atividades e dados/A1 - primeiro mapa/bio1_br.asc")
plot(myraster)
# To see the original projection
myraster

# First setting the original projection

crs.azim <- CRS("+proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 
                +units=m +no_defs")

proj4string(myraster) <- crs.azim

# Then reproject to the chosen projection
myraster_albers <- projectRaster(myraster, crs=crs.albers)
plot(myraster_albers)
myraster_albers


# Saving reprojected objects

writeOGR(mypolygon_albers, dsn = "D:/mydirectory",
         layer = "mypolygon_albers", driver="ESRI Shapefile", overwrite=T)


writeRaster(myraster_albers, "D:/mydirectory/bio1_albers.tif", format="GTiff",
            overwrite=T)

