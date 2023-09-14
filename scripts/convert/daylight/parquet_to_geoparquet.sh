#!/bin/bash

# Extract data from overture-maps data based on bounds and convert to geoparquet using gpq
# The extracts can be used for example in QGIS or as input to create GeoJSON files.
#
# ToDo: spatial partitioning?

DAYLIGHT_DATA_PATH="./data/daylight"
OUTPUT_PATH="./data/output/geoparquet"
COUNTRY_BOUNDS_FILE="./scripts/convert/country_bounds.parquet"

#############################
## THEME: WATER
#############################

duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT 
            a.geometry_id,
            a.class,
            a.subclass,
            a.metadata,
            a.original_source_tags,
            a.names,
            a.quadkey,
            ST_AsWKB(ST_GeomFromText(a.wkt)) as geometry,
            a.theme
        FROM read_parquet('$DAYLIGHT_DATA_PATH/theme=water/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Intersects(ST_GeomFromText(a.wkt), ST_GeomFromWkb(b.geometry))
    ) 
    TO 'water.parquet' (FORMAT 'parquet');
"""
gpq convert water.parquet $OUTPUT_PATH/water_geo.parquet --from=parquet --to=geoparquet
rm water.parquet

#############################
## THEME: PLACENAME
#############################

duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT
            a.geometry_id,
            a.class,
            a.subclass,
            a.metadata,
            a.original_source_tags,
            a.names,
            a.quadkey,
            ST_AsWKB(ST_GeomFromText(a.wkt)) as geometry,
            a.theme
        FROM read_parquet('$DAYLIGHT_DATA_PATH/theme=placename/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Intersects(ST_GeomFromText(a.wkt), ST_GeomFromWkb(b.geometry))
    ) 
    TO 'placename.parquet' (FORMAT 'parquet');
"""
gpq convert placename.parquet $OUTPUT_PATH/placename_geo.parquet --from=parquet --to=geoparquet
rm placename.parquet

#############################
## THEME: LANDUSE
#############################

duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT
            a.geometry_id,
            a.class,
            a.subclass,
            a.metadata,
            a.original_source_tags,
            a.names,
            a.quadkey,
            ST_AsWKB(ST_GeomFromText(a.wkt)) as geometry,
            a.theme
        FROM read_parquet('$DAYLIGHT_DATA_PATH/theme=landuse/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Intersects(ST_GeomFromText(a.wkt), ST_GeomFromWkb(b.geometry))
    ) 
    TO 'landuse.parquet' (FORMAT 'parquet');
"""
gpq convert landuse.parquet $OUTPUT_PATH/landuse_geo.parquet --from=parquet --to=geoparquet
rm landuse.parquet

#############################
## THEME: LAND
#############################

duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT
            a.geometry_id,
            a.class,
            a.subclass,
            a.metadata,
            a.original_source_tags,
            a.names,
            a.quadkey,
            ST_AsWKB(ST_GeomFromText(a.wkt)) as geometry,
            a.theme
        FROM read_parquet('$DAYLIGHT_DATA_PATH/theme=land/*', hive_partitioning=1) AS a, read_parquet('$COUNTRY_BOUNDS_FILE') AS b
        WHERE ST_Intersects(ST_GeomFromText(a.wkt), ST_GeomFromWkb(b.geometry))
    ) 
    TO 'land.parquet' (FORMAT 'parquet');
"""
gpq convert land.parquet $OUTPUT_PATH/land_geo.parquet --from=parquet --to=geoparquet
rm land.parquet