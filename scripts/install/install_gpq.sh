# Define the URL of the gpq binary tarball and the version
GPQ_VERSION="v0.11.0"
GPQ_URL="https://github.com/planetlabs/gpq/releases/download/${GPQ_VERSION}/gpq-linux-amd64.tar.gz"

# Define the destination directory
DEST_DIR="/usr/local/bin"

# Download and extract gpq binary
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit 1
curl -LO "$GPQ_URL"
tar -zxvf "gpq-linux-amd64.tar.gz"
mv gpq "$DEST_DIR"
rm -rf "$TMP_DIR"

# Check if the move was successful
if [ -e "${DEST_DIR}/gpq" ]; then
  echo "gpq has been successfully installed to ${DEST_DIR}"
  echo "You can now use 'gpq' command system-wide."
else
  echo "Installation failed. Please check the script and try again."
fi