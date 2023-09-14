#!/bin/bash

# Create GeoJSON files from our geoparquet files which we can than
# use to generate PMTiles. Currently not all metadata is written
# to the GeoJSON files.

INPUT_PATH="./data/output/geoparquet"
OUTPUT_PATH="./data/output/geojson"

#############################
## WATER
#############################
# Very nice strings can be found in names...
duckdb -c """
    LOAD spatial; 
    COPY (
        SELECT
            class,
            subclass,
            COALESCE(replace(json_extract(replace(replace(names, '\\\\\\\\', ''), '\\\\\"', '''')::json, '$.local'), '\"', '')::varchar, '') as name,
            --COALESCE(replace(json_extract(metadata::json,'\$.wikidata'), '\"', '')::varchar, '') as wikidata,
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/water_geo.parquet')
    ) 
    TO '$OUTPUT_PATH/water.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""
duckdb -c ""

#############################
## PLACENAME
#############################
# Very nice strings can be found in names...
duckdb -c """
    LOAD spatial; 
    COPY (
        SELECT
            class,
            subclass,
            COALESCE(replace(json_extract(names::json,'\$.local'), '\"', '')::varchar, '') as name,
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/placename_geo.parquet')
    ) 
    TO '$OUTPUT_PATH/placename.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""
duckdb -c ""

#############################
## LANDUSE
#############################
duckdb -c """
    LOAD spatial; 
    COPY (
        SELECT
            class,
            subclass,
            COALESCE(replace(json_extract(replace(replace(names, '\\\\\\\\', ''), '\\\\\"', '''')::json, '$.local'), '\"', '')::varchar, '') as name,
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/landuse_geo.parquet')
    ) 
    TO '$OUTPUT_PATH/landuse.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""
duckdb -c ""

#############################
## LAND
#############################
duckdb -c """
    LOAD spatial; 
    COPY (
        SELECT
            class,
            subclass,
            COALESCE(replace(json_extract(replace(replace(names, '\\\\\\\\', ''), '\\\\\"', '''')::json, '$.local'), '\"', '')::varchar, '') as name,
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/land_geo.parquet')
    ) 
    TO '$OUTPUT_PATH/land.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""
duckdb -c ""