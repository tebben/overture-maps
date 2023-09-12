#!/bin/bash

# Create GeoJSON files from our geoparquet files which we can than
# use to generate PMTiles. Currently not all metadata is written
# to the GeoJSON files.

INPUT_PATH="./data/output/geoparquet"
OUTPUT_PATH="./data/output/geojson"

#############################
## ADMINS
#############################
duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT
            type,
            subType,
            localityType,
            adminLevel, 
            isoCountryCodeAlpha2,
            COALESCE(replace(json_extract(names::json,'\$.key_value[0].value.list[0].key_value[0].value'), '\"', '')::varchar, '') as name,
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/admins_geo.parquet')
    ) 
    TO '$OUTPUT_PATH/admins.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""

#############################
## ROADS
#############################
duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT
            --type,
            --subType,
            COALESCE(replace(json_extract(road::json,'\$.class'),'\"','')::varchar, '') as class,
            COALESCE(replace(json_extract(road::json,'\$.surface'),'\"','')::varchar, '') as surface,
            COALESCE(replace(json_extract(road::json,'\$.roadNames.common[0].value'),'\"','')::varchar, '') as roadName,
            COALESCE(replace(json_extract(road::json,'\$.restrictions.speedLimits[0].maxSpeed[0]'),'\"','')::int32, -1) as speedLimit,
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/transportation_geo.parquet')
        WHERE type = 'segment'
        AND subType = 'road'
    ) 
    TO '$OUTPUT_PATH/roads.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""


#############################
## Buildings
#############################
duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT
            COALESCE(height, -1) as height,
            COALESCE(numFloors, -1) as numFloors,
            COALESCE(class, '') as class,
            COALESCE(replace(json_extract(names::json,'\$.common[0].value'),'\"','')::varchar, '') as name,
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/buildings_geo.parquet')
    ) 
    TO '$OUTPUT_PATH/buildings.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""

#############################
## Places
#############################
duckdb -c """
    INSTALL spatial; 
    LOAD spatial; 
    COPY (
        SELECT
            COALESCE(replace(json_extract(addresses::json,'\$[0].locality'),'\"','')::varchar, '') as locality,
            COALESCE(replace(json_extract(addresses::json,'\$[0].region'),'\"','')::varchar, '') as region,
            COALESCE(replace(json_extract(addresses::json,'\$[0].postcode'),'\"','')::varchar, '') as postcode,
            COALESCE(replace(json_extract(addresses::json,'\$[0].freeform'),'\"','')::varchar, '') as freeform,
            COALESCE(replace(json_extract(categories::json,'\$.main'),'\"','')::varchar, '') as category,
            COALESCE(replace(json_extract(names::json,'\$.common[0].value'),'\"','')::varchar, '') as name,
            COALESCE(confidence, 0),
            ST_GeomFromWkb(geometry) AS geometry
        FROM read_parquet('$INPUT_PATH/places_geo.parquet')
    ) 
    TO '$OUTPUT_PATH/places.geojson'
    WITH (FORMAT GDAL, DRIVER 'GeoJSON');
"""
