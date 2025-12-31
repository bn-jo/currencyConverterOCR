#!/bin/bash

# Currency Converter OCR - Setup and Run Script
# This script will set up the project and run it on your connected device

set -e  # Exit on error

echo "🚀 Currency Converter OCR - Setup Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
echo "📱 Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo ""
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    echo ""
    echo "For macOS:"
    echo "  1. Download Flutter SDK"
    echo "  2. Extract to desired location"
    echo "  3. Add to PATH in ~/.zshrc or ~/.bash_profile:"
    echo "     export PATH=\"\$PATH:/path/to/flutter/bin\""
    echo "  4. Run: source ~/.zshrc (or ~/.bash_profile)"
    exit 1
fi

echo -e "${GREEN}✅ Flutter found!${NC}"
flutter --version
echo ""

# Run Flutter doctor
echo "🔍 Running Flutter doctor..."
flutter doctor
echo ""

# Check if API key file exists
echo "🔑 Checking API key configuration..."
if [ ! -f "lib/core/config/api_keys.dart" ]; then
    echo -e "${YELLOW}⚠️  API key file not found. Creating from example...${NC}"
    cp lib/core/config/api_keys.example.dart lib/core/config/api_keys.dart
    echo -e "${GREEN}✅ Created lib/core/config/api_keys.dart${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  NOTE: You need to add your API key for live rates${NC}"
    echo "   1. Get free API key from: https://www.exchangerate-api.com/"
    echo "   2. Edit lib/core/config/api_keys.dart"
    echo "   3. Replace 'YOUR_API_KEY_HERE' with your actual key"
    echo ""
    echo "   For now, the app will run but conversions will fail without a key."
    echo ""
else
    echo -e "${GREEN}✅ API key file exists${NC}"
fi

# Install dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Generate Hive adapters
echo "⚙️  Generating code (Hive adapters)..."
echo "   This may take a minute..."

flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  Code generation had warnings, but continuing...${NC}"
fi

echo -e "${GREEN}✅ Code generation complete${NC}"
echo ""

# Check connected devices
echo "📱 Checking for connected devices..."
flutter devices

DEVICE_COUNT=$(flutter devices | grep -c "mobile" || true)

if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo ""
    echo -e "${RED}❌ No devices found!${NC}"
    echo ""
    echo "Please connect your phone via USB and:"
    echo ""
    echo "For Android:"
    echo "  1. Enable Developer Mode (Settings → About → Tap Build Number 7 times)"
    echo "  2. Enable USB Debugging (Settings → Developer Options)"
    echo "  3. Connect via USB and allow debugging"
    echo ""
    echo "For iPhone:"
    echo "  1. Connect via USB"
    echo "  2. Trust this computer when prompted"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Found $DEVICE_COUNT device(s)${NC}"
echo ""

# Ask user if they want to run
read -p "🚀 Ready to run the app! Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup complete! Run 'flutter run' when ready."
    exit 0
fi

# Run the app
echo ""
echo "🏃 Running app on device..."
echo "   First build may take 5-10 minutes..."
echo ""

flutter run

echo ""
echo -e "${GREEN}✅ Done!${NC}"
