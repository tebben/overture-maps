#!/bin/bash

# Set the local directory path
local_directory="./data/daylight"

# Create the local directory if it doesn't exist
if [ ! -d "$local_directory" ]; then
  mkdir -p "$local_directory"
  echo "Created directory: $local_directory"
fi

# Download using AWS CLI and S3
source_bucket_water="s3://daylight-openstreetmap/earth/release=v1.29/theme=water"
source_bucket_placename="s3://daylight-openstreetmap/earth/release=v1.29/theme=placename"
source_bucket_land="s3://daylight-openstreetmap/earth/release=v1.29/theme=land"
source_bucket_landuse="s3://daylight-openstreetmap/earth/release=v1.29/theme=landuse"

aws s3 cp --region us-west-2 --no-sign-request --recursive "$source_bucket_water" "$local_directory/theme=water"
aws s3 cp --region us-west-2 --no-sign-request --recursive "$source_bucket_placename" "$local_directory/theme=placename"
aws s3 cp --region us-west-2 --no-sign-request --recursive "$source_bucket_land" "$local_directory/theme=land"
aws s3 cp --region us-west-2 --no-sign-request --recursive "$source_bucket_landuse" "$local_directory/theme=landuse"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download completed successfully."
else
  echo "Download failed. Please check the source S3 bucket and try again."
  exit 1
fi
