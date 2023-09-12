#!/bin/bash

# Define the URL of the binary
URL="https://github.com/protomaps/go-pmtiles/releases/download/v1.9.2/go-pmtiles_1.9.2_Linux_x86_64.tar.gz"

# Define the temporary directory for downloading and extracting
TMP_DIR="/tmp/go-pmtiles"

# Define the destination directory
DEST_DIR="/usr/local/bin"

# Create a temporary directory
mkdir -p "$TMP_DIR"

# Navigate to the temporary directory
cd "$TMP_DIR" || exit 1

# Download the binary from the URL
curl -L -o binary.tar.gz "$URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download the binary."
  exit 1
fi

# Extract the binary
tar -xzvf binary.tar.gz

# Move the binary to the destination directory
sudo mv pmtiles "$DEST_DIR/"

# Check if the move was successful
if [ $? -ne 0 ]; then
  echo "Failed to move the binary to $DEST_DIR."
  exit 1
fi

# Cleanup: Remove the temporary directory
rm -rf "$TMP_DIR"

echo "Binary installed to $DEST_DIR"
echo "Cleanup complete."