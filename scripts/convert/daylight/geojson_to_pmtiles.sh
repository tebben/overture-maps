#!/bin/bash

INPUT_PATH="./data/output/geojson"
OUTPUT_PATH="./data/output/pmtiles"

# When creating pmtiles with tippecanoe we get Version 2 of PMTiles
# converting using pmtiles convert gives us an error
# first create mbtiles using tippecanoe and convert mbtiles to pmtiles
# using pmtiles CLI, this results in PMTiles V3

#############################
## WATER
#############################
echo "Generating water.mbtiles"
tippecanoe -Z6 -z12 --projection=EPSG:4326 -o $OUTPUT_PATH/water.mbtiles -l water \
    --detect-shared-borders \
    --drop-smallest-as-needed \
    -j '{ "*": [ "any", [ "in", "class", "river", "ocean", "lake" ], [ "all", [ ">=", "$zoom", 9 ], [ "in", "class", "stream" ]], [ ">=", "$zoom", 12]] }' \
    $INPUT_PATH/water.geojson \
    --force

#############################
## LAND
#############################
echo "Generating land.mbtiles"
tippecanoe -Z9 -z12 --projection=EPSG:4326 -o $OUTPUT_PATH/land.mbtiles -l land \
    --detect-shared-borders \
    --drop-smallest-as-needed \
    -j '{ "*": [ "any", [ "in", "class", "glacier" ], [ "all", [ ">=", "$zoom", 5 ], [ "in", "class", "forest", "sand" ]], [ "all", [ ">=", "$zoom", 7 ], [ "in", "class", "reef", "wetland" ]], [ "all", [ ">=", "$zoom", 9 ], [ "in", "class", "grass", "scrub" ]], [ ">=", "$zoom", 12]] }' \
    $INPUT_PATH/land.geojson \
    --force

#############################
## LANDUSE
#############################
echo "Generating landuse.mbtiles"
tippecanoe -Z10 -z12 --projection=EPSG:4326 -o $OUTPUT_PATH/landuse.mbtiles -l landuse \
    --detect-shared-borders \
    --drop-smallest-as-needed \
    -j '{ "*": [ "any", [ "all", [ ">=", "$zoom", 10 ], [ "in", "class", "agriculture", "protected" ]], [ "all", [ ">=", "$zoom", 11 ], [ "in", "class", "park", "airport" ]], [ ">=", "$zoom", 12]] }' \
    $INPUT_PATH/landuse.geojson \
    --force

#############################
## PLACENAME
#############################
echo "Generating placename.mbtiles"
tippecanoe -Z2 -z12 -B6 --projection=EPSG:4326 -o $OUTPUT_PATH/placename.mbtiles -l placename \
    -j '{ "*": [ "any", [ "in", "subclass", "megacity", "metropolis" ], [ "all", [ ">=", "$zoom", 3 ], [ "in", "subclass", "city", "municipality" ]],  [ "all", [ ">=", "$zoom", 9 ], [ "in", "subclass", "town", "hamlet", "vilage" ]], [ ">=", "$zoom", 12]] }' \
    $INPUT_PATH/placename.geojson \
    --force

# join all mbtiles into 1 big file
echo "merge tiles"
tile-join -pk -o $OUTPUT_PATH/daylight.mbtiles $OUTPUT_PATH/water.mbtiles $OUTPUT_PATH/land.mbtiles $OUTPUT_PATH/landuse.mbtiles $OUTPUT_PATH/placename.mbtiles --force

# tippecanoe outputs pmtiles V2, we want v3
echo "convert mbtiles to pmtiles"
pmtiles convert $OUTPUT_PATH/daylight.mbtiles $OUTPUT_PATH/daylight.pmtiles

echo "Cleaning up intermediate files"
# remove mbtiles file
rm $OUTPUT_PATH/water.mbtiles
rm $OUTPUT_PATH/land.mbtiles
rm $OUTPUT_PATH/landuse.mbtiles
rm $OUTPUT_PATH/placename.mbtiles
rm $OUTPUT_PATH/daylight.mbtiles

# copy pmtiles to the viewer
cp $OUTPUT_PATH/daylight.pmtiles ./viewer/dist/daylight.pmtiles

echo "Finished!"