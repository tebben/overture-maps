#!/bin/bash

MINICONDA_VERSION="latest"  # You can replace with a specific version if desired
INSTALL_DIR="$HOME/miniconda3"

# Download the Miniconda installer script
if [ "$MINICONDA_VERSION" == "latest" ]; then
  MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
else
  MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"
fi

echo "Downloading Miniconda installer..."
wget "$MINICONDA_URL" -O miniconda.sh

# Make the installer script executable
chmod +x miniconda.sh

# Run the installer
./miniconda.sh -b -p "$INSTALL_DIR"

# Remove the installer script
rm miniconda.sh

# Add Miniconda to PATH
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> ~/.bashrc  # For Bash
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> ~/.zshrc   # For Zsh

# Activate Miniconda
source ~/.bashrc  # For Bash
source ~/.zshrc   # For Zsh

conda config --add channels conda-forge
conda config --set channel_priority flexible

echo "Miniconda installation complete. You can now create Conda environments and install packages."