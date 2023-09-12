#!/bin/bash

# Create WKT variable with the provided wkt, if empty take a default one
WKT="${1:-"POLYGON ((5.300171258675078 51.69073045148227, 5.300611111690557 51.68445866410491, 5.315566114235423 51.68486772020245, 5.313366849155244 51.690866785036064, 5.300171258675078 51.69073045148227))"}"

duckdb -c """
    INSTALL spatial;
    LOAD spatial;
    COPY (
        SELECT ST_AsWKB(ST_GeomFromText('$WKT')) as geometry
    )
    TO './convert/bounds.parquet';
"""