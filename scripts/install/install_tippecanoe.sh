#!/bin/bash

sudo apt-get install -y software-properties-common build-essential libsqlite3-dev zlib1g-dev make

git clone https://github.com/mapbox/tippecanoe.git
cd tippecanoe
make
sudo make install
sudo mv tippecanoe /usr/local/bin/
cd ..
sudo rm -rf ./tippecanoe