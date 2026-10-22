
# R Script: Double Stereographic Projection (Rijksdriehoekstelsel - RD)
# Verification of coordinates for Poolanker P (52.2500° N, 5.2200° E) 
# relative to Amersfoort origin (52.15616111° N, 5.38763889° E)

# Install/Load required libraries if needed (e.g., sf, PROJ)
# install.packages("sf")
library(sf)

# Define Amersfoort origin and target coordinates in WGS84 (EPSG:4326)
origin_wgs84 <- st_sfc(st_point(c(5.38763889, 52.15616111)), crs = 4326)
target_wgs84 <- st_sfc(st_point(c(5.2200, 52.2500)), crs = 4326)

# Define Dutch RD New projection string (EPSG:28992)
# +proj=sterea +lat_0=52.15616111 +lon_0=5.38763889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs
rd_proj_str <- "+proj=sterea +lat_0=52.15616111 +lon_0=5.38763889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

# Transform points to RD
origin_rd <- st_transform(origin_wgs84, crs = rd_proj_str)
target_rd <- st_transform(target_wgs84, crs = rd_proj_str)

print("Amersfoort Origin RD Coordinates:")
print(st_coordinates(origin_rd))

print("Target (Poolanker P) RD Coordinates:")
print(st_coordinates(target_rd))

# Manual verification calculation using standard formulas (Rijkstriangulation / Bessel ellipsoid)
# ...
