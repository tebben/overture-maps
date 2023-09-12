#!/bin/bash

INPUT_PATH="./data/output/geojson"
OUTPUT_PATH="./data/output/pmtiles"
#OUTPUT_PATH="./viewer/dist"

# When creating pmtiles with tippecanoe we get Version 2 of PMTiles
# converting using pmtiles convert gives us an error
# first create mbtiles using tippecanoe and convert mbtiles to pmtiles
# using pmtiles CLI, this results in PMTiles V3

#-zg: Automatically choose a maxzoom that should be sufficient to clearly distinguish the features and the detail within each feature
#--drop-densest-as-needed: If the tiles are too big at low zoom levels, drop the least-visible features to allow tiles to be created with those features that remain
#--cluster-distance=10


tippecanoe -Z1 -z22 --projection=EPSG:4326 -o $OUTPUT_PATH/admins.mbtiles -l admins --drop-densest-as-needed $INPUT_PATH/admins.geojson --force
tippecanoe -Z14 -z22 --projection=EPSG:4326 -o $OUTPUT_PATH/buildings.mbtiles -l buildings --drop-densest-as-needed $INPUT_PATH/buildings.geojson --force
# only motorway, primary, secondary when zoom lower than 13
tippecanoe -o $OUTPUT_PATH/roads.mbtiles --coalesce-smallest-as-needed  -j '{ "*": [ "any", [ ">=", "$zoom", 13 ], [ "in", "class", "motorway", "primary", "secondary" ] ] }' $INPUT_PATH/roads.geojson --force
#tippecanoe -Z7 -z22 --projection=EPSG:4326 --coalesce-smallest-as-needed -o $OUTPUT_PATH/roads.mbtiles -l roads $INPUT_PATH/roads.geojson --force
tippecanoe -Z13 -z22 --projection=EPSG:4326 -o $OUTPUT_PATH/places.mbtiles -l places $INPUT_PATH/places.geojson --force

# join all mbtiles into 1 big file
tile-join -o $OUTPUT_PATH/overture.mbtiles $OUTPUT_PATH/admins.mbtiles $OUTPUT_PATH/roads.mbtiles $OUTPUT_PATH/buildings.mbtiles $OUTPUT_PATH/places.mbtiles --force

# tippecanoe outputs pmtiles V2, we want v3
pmtiles convert $OUTPUT_PATH/overture.mbtiles $OUTPUT_PATH/overture.pmtiles

# remove mbtiels file
rm $OUTPUT_PATH/admins.mbtiles
rm $OUTPUT_PATH/buildings.mbtiles
rm $OUTPUT_PATH/roads.mbtiles
rm $OUTPUT_PATH/overture.mbtiles
rm $OUTPUT_PATH/places.mbtiles

# copy pmtiles to our viewer
cp $OUTPUT_PATH/overture.pmtiles ./viewer/dist/overture.pmtiles