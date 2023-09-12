# overture-maps

Playing around with Overture Maps data. A notebook to play around in and some scripts to extract and convert data to geoparquet, geojson, pmtiles.

## Download overture-maps data

Run scripts/download_overture_data.sh to download all overture parquet files from AWS without needing to login. This will take some time to run since this is around 200GB. This script will install AWD cli if not found on the system. Using duckdb we could also directly request the data we need because the data is hive partitioned but I prefer to have everything locally.

```sh
./scripts/download_overture_data.sh
```

## Playing around with the overture data in a notebook

Notebook to have a closer look at the data and see if we can show something on a map.

### Install miniconda

Install miniconda if not installed yet.

```sh
./scripts/install_miniconda.sh
```

### Create environment

Create a conda environment and install some dependencies.

```sh
conda create -n overture python=3.10 
conda activate overture
conda install pip
pip install -r requirements.txt
```

### Open notebook

Open ./notebooks/hello_overture.ipynb and select kernel overture from our conda environment.

## Extract data, convert to geoparquet and create PMTiles

Make sure DuckDB, gpq and pmtiles are installed

```sh
sudo ./scripts/install_duckdb.sh
sudo ./scripts/install_gpq.sh
sudo ./scripts/install_pmtiles.sh
```

### Create bounds

In our test we don't want to do the whole world so we create some bounds, in this case country bounds of The Netherlands, supply the country code to the script. In the next example we create bounds for The Netherlands.

```sh
./scripts/create_country_bounds.sh NL
```

### Extract data and convert to geoparquet

The following script will create geoparquet files for all overture-maps themes with only data inside our given bounds, for pmtiles we don't need geoparquet but it's nice to have anyways. This can take some time, no fancy things are done such as spatial partitioning/indexing.

```sh
./scripts/convert/to_geoparquet.sh
```

### Create GeoJSON

For the PMTiles creation we need GeoJSON files `parquet_to_geojson.sh` creates geojson files for each theme from our geoparquet files which can be feeded into tippecanoe. Not every field is added to the GeoJSON features, if you miss something you can update the queries.

```sh
./scripts/convert/parquet_to_geojson.sh
```

### Create PMTiles

When we have the GeoJSON files we can create our PMTiles using tippecanoe.

```sh
./scripts/convert/geojson_to_pmtiles.sh
```

This will create mbtiles for each theme, merge them and convert to PMTiles. Directly creating pmtiles with tippecanoe resulted in a PMTiles V2 files which could not be converted to v3, therefore mbtiles are created and later converted into PMTiles using `pmtiles convert`

### Run viewer to view PMTiles

In the folder `viewer` a maplibre-gl viewer can be found which loads the PMTiles file locally.

```sh
cd viewer
npm install
npm run dev
```