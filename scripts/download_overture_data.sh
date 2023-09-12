#!/bin/bash

# Set the local directory path
local_directory="./data/overture_maps"

# Create the local directory if it doesn't exist
if [ ! -d "$local_directory" ]; then
  mkdir -p "$local_directory"
  echo "Created directory: $local_directory"
fi

# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
  echo "AWS CLI is not installed. Installing it now..."

  # Install AWS CLI (you can modify this command for your specific platform)
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # For Linux
    curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # For macOS
    curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-macos.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws
  else
    echo "Unsupported OS. Please install AWS CLI manually."
    exit 1
  fi

  # Check if the installation was successful
  if [ $? -eq 0 ]; then
    echo "AWS CLI installed successfully."
  else
    echo "Failed to install AWS CLI. Please install it manually or ensure it's in your PATH."
    exit 1
  fi
else
  echo "AWS CLI is already installed."
fi

# Download using AWS CLI and S3
source_bucket="s3://overturemaps-us-west-2/release/2023-07-26-alpha.0/"
aws s3 cp --region us-west-2 --no-sign-request --recursive "$source_bucket" "$local_directory"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download completed successfully."
else
  echo "Download failed. Please check the source S3 bucket and try again."
  exit 1
fi
