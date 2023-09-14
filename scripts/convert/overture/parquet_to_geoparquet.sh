#!/bin/bash

# Extract data from overture-maps data based on bounds and convert to geoparquet using gpq
# The extracts can be used for example in QGIS or as input to create GeoJSON files.
#
# ToDo: spatial partitioning?

OVERTURE_MAPS_DATA_PATH="./data/overture_maps"
OUTPUT_PATH="./data/output/geoparquet"
COUNTRY_BOUNDS_FILE="./scripts/convert/country_bounds.parquet"

#############################
## THEME: ADMINS
#############################

duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT a.* 
        FROM read_parquet('$OVERTURE_MAPS_DATA_PATH/theme=admins/type=*/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Within(ST_GeomFromWKB(a.geometry), ST_GeomFromWkb(b.geometry))
    ) 
    TO 'admins.parquet' (FORMAT 'parquet');
"""
gpq convert admins.parquet $OUTPUT_PATH/admins_geo.parquet --from=parquet --to=geoparquet
rm admins.parquet

#############################
## THEME: TRANSPORTATION
#############################

duckdb -c """
    SET temp_directory='duck.tmp';
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT a.* 
        FROM read_parquet('$OVERTURE_MAPS_DATA_PATH/theme=transportation/type=*/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Intersects(ST_GeomFromWKB(a.geometry), ST_GeomFromWKB(b.geometry))
    ) 
    TO 'transportation.parquet' (FORMAT 'parquet');
"""
gpq convert transportation.parquet $OUTPUT_PATH/transportation_geo.parquet --from=parquet --to=geoparquet
rm transportation.parquet

#############################
## THEME: BULDINGS
#############################

duckdb -c """
    SET temp_directory='duck.tmp';
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT a.* 
        FROM read_parquet('$OVERTURE_MAPS_DATA_PATH/theme=buildings/type=building/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Intersects(ST_GeomFromWKB(a.geometry), ST_GeomFromWKB(b.geometry))
    ) 
    TO 'buildings.parquet' (FORMAT 'parquet');
"""
gpq convert buildings.parquet $OUTPUT_PATH/buildings_geo.parquet --from=parquet --to=geoparquet
rm buildings.parquet

#############################
## THEME: PLACES
#############################

duckdb -c """
    SET temp_directory='duck.tmp';
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT a.* 
        FROM read_parquet('$OVERTURE_MAPS_DATA_PATH/theme=places/type=*/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Intersects(ST_GeomFromWKB(a.geometry), ST_GeomFromWKB(b.geometry))
    ) 
    TO 'places.parquet' (FORMAT 'parquet');
"""
gpq convert places.parquet $OUTPUT_PATH/places_geo.parquet --from=parquet --to=geoparquet
rm places.parquet