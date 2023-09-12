#!/bin/bash

# Download DuckDB CLI binary
wget https://github.com/duckdb/duckdb/releases/download/v0.8.1/duckdb_cli-linux-amd64.zip

# Unzip the downloaded archive
unzip duckdb_cli-linux-amd64.zip

# Move the DuckDB binary to /usr/local/bin/
sudo mv duckdb /usr/local/bin/

# Remove the downloaded archive
rm duckdb_cli-linux-amd64.zip

# Print a message indicating the installation is complete
echo "DuckDB CLI has been successfully installed."

# Optionally, check DuckDB CLI version
duckdb --version