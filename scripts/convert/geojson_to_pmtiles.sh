#!/bin/bash

INPUT_PATH="./data/output/geojson"
OUTPUT_PATH="./data/output/pmtiles"

# When creating pmtiles with tippecanoe we get Version 2 of PMTiles
# converting using pmtiles convert gives us an error
# first create mbtiles using tippecanoe and convert mbtiles to pmtiles
# using pmtiles CLI, this results in PMTiles V3

#############################
## ADMINS
#############################
echo "Generating admins.mbtiles"
tippecanoe -zg -z20 --projection=EPSG:4326 -o $OUTPUT_PATH/admins.mbtiles -l admins --drop-densest-as-needed $INPUT_PATH/admins.geojson --force

#############################
## BUILDINGS
#############################
echo "Generating buildings.mbtiles"
tippecanoe -Z13 -z20 --projection=EPSG:4326 -o $OUTPUT_PATH/buildings.mbtiles -l buildings --drop-densest-as-needed $INPUT_PATH/buildings.geojson --force

#############################
## ROADS
#############################
# Generate zoom 5-22 and remove features at lower zoom levels
#
# filter any expression = any of the expression returns true
# 1) [ "in", "class", "motorway" ]
#    Return true if class = motorways: always take features where class is motorway
# 2) [ "all", [ ">=", "$zoom", 9 ], [ "in", "class", "primary", "secondary" ]]
#    All expressions should be true, zoom is greater than or equals to 9 and class = "primary" or "secondary"
# 3) [ ">=", "$zoom", 15]]
#    If zoom is greater than or equals to 15 return true = render everything after and at zoom 15
echo "Generating roads.mbtiles"
tippecanoe -Z5 -z20 -o $OUTPUT_PATH/roads.mbtiles --coalesce-smallest-as-needed -j '{ "*": [ "any", [ "in", "class", "motorway" ], [ "all", [ ">=", "$zoom", 9 ], [ "in", "class", "primary", "secondary" ]],  [ "all", [ ">=", "$zoom", 11 ], [ "in", "class", "tertiary", "residential", "livingStreet" ]], [ ">=", "$zoom", 12]] }' -l roads $INPUT_PATH/roads.geojson --force

#############################
## PLACES
#############################
echo "Generating places.mbtiles"
tippecanoe -Z14 -z20 --projection=EPSG:4326 -o $OUTPUT_PATH/places.mbtiles -l places $INPUT_PATH/places.geojson --force


# join all mbtiles into 1 big file
# -pk din't skip tiles larger than 500k
echo "merge tiles"
tile-join -pk -o $OUTPUT_PATH/overture.mbtiles $OUTPUT_PATH/admins.mbtiles $OUTPUT_PATH/roads.mbtiles $OUTPUT_PATH/buildings.mbtiles $OUTPUT_PATH/places.mbtiles --force

# tippecanoe outputs pmtiles V2, we want v3
echo "convert mbtiles to pmtiles"
pmtiles convert $OUTPUT_PATH/overture.mbtiles $OUTPUT_PATH/overture.pmtiles

echo "Cleaning up intermediate files"
# remove mbtiles file
rm $OUTPUT_PATH/admins.mbtiles
rm $OUTPUT_PATH/buildings.mbtiles
rm $OUTPUT_PATH/roads.mbtiles
rm $OUTPUT_PATH/overture.mbtiles
rm $OUTPUT_PATH/places.mbtiles

# copy pmtiles to the viewer
cp $OUTPUT_PATH/overture.pmtiles ./viewer/dist/overture.pmtiles

echo "Finished!"