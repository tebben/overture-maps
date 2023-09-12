#!/bin/bash

# Set a default value for COUNTRY_CODE
COUNTRY_CODE=${1:-"NL"}

# Create csv containing wkt with the bounds for a country
duckdb -c """
    LOAD spatial; 
    COPY(
        SELECT geometry as geometry 
        FROM read_parquet('../data/overture_maps/theme=admins/type=*/*', hive_partitioning=1) 
        WHERE adminLevel = 2 
        AND isoCountryCodeAlpha2 = '$COUNTRY_CODE'
    ) TO './convert/country_bounds.parquet';
"""