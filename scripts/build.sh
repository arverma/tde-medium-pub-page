#!/usr/bin/env bash
set -euo pipefail

# Build the site: copy static files to _site/ and inject latest stories from Medium RSS
# Mirrors arverma.dev build process (Astro build + Medium RSS fetch at build time)

BUILD_DIR="_site"

echo "Building site..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy all static files to build directory
echo "Copying static files..."
cp -r *.html css js assets *.txt *.xml "$BUILD_DIR/" 2>/dev/null || true

# Ensure CNAME is included for custom domain
if [ -f CNAME ]; then
  cp CNAME "$BUILD_DIR/"
fi

# Fetch latest stories from Medium RSS and inject into built index.html
echo "Fetching latest stories from Medium RSS..."
python3 scripts/update-latest-stories.py "$BUILD_DIR/index.html"

echo "Build complete: $BUILD_DIR/"
