#!/bin/bash

# Fonts Downloader
# This script downloads Poppins and Nunito Sans fonts from Google Fonts

set -e

echo "🎨 Fonts Downloader"
echo "========================="
echo ""

# Create fonts directory if it doesn't exist
FONTS_DIR="assets/fonts"
mkdir -p "$FONTS_DIR"

echo "📁 Fonts directory: $FONTS_DIR"
echo ""

# Temporary directory for downloads
TEMP_DIR=$(mktemp -d)
echo "📥 Downloading fonts to temporary directory..."
echo ""

# Download Poppins
echo "⬇️  Downloading Poppins..."
curl -L "https://github.com/googlefonts/tajawal/raw/main/fonts/ttf/Tajawal-Regular.ttf" -o "$TEMP_DIR/Tajawal-Regular.ttf"
curl -L "https://github.com/googlefonts/tajawal/raw/main/fonts/ttf/Tajawal-Medium.ttf" -o "$TEMP_DIR/Tajawal-Medium.ttf"
curl -L "https://github.com/googlefonts/tajawal/raw/main/fonts/ttf/Tajawal-SemiBold.ttf" -o "$TEMP_DIR/Tajawal-SemiBold.ttf"
curl -L "https://github.com/googlefonts/tajawal/raw/main/fonts/ttf/Tajawal-Bold.ttf" -o "$TEMP_DIR/Tajawal-Bold.ttf"

# Download Nunito Sans
echo "⬇️  Downloading Nunito Sans..."
curl -L "https://github.com/google/fonts/raw/main/ofl/nunitosans/NunitoSans-Regular.ttf" -o "$TEMP_DIR/NunitoSans-Regular.ttf"
curl -L "https://github.com/google/fonts/raw/main/ofl/nunitosans/NunitoSans-Medium.ttf" -o "$TEMP_DIR/NunitoSans-Medium.ttf"
curl -L "https://github.com/google/fonts/raw/main/ofl/nunitosans/NunitoSans-SemiBold.ttf" -o "$TEMP_DIR/NunitoSans-SemiBold.ttf"
curl -L "https://github.com/google/fonts/raw/main/ofl/nunitosans/NunitoSans-Bold.ttf" -o "$TEMP_DIR/NunitoSans-Bold.ttf"

echo ""
echo "📦 Moving fonts to $FONTS_DIR..."

# Move fonts to assets/fonts
mv "$TEMP_DIR"/*.ttf "$FONTS_DIR/"

# Clean up
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Fonts downloaded successfully!"
echo ""
echo "📋 Downloaded fonts:"
ls -lh "$FONTS_DIR"/*.ttf

echo ""
echo "🎉 Done! Run 'flutter pub get' to use the fonts."
