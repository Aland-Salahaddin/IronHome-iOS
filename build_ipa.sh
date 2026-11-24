#!/usr/bin/env bash
#
# build_ipa.sh
# Compiles IronHome and packages a sideloadable IronHome.ipa for Sideloadly
# Run this on any macOS system with Xcode command line tools installed.
#

set -e

echo "=================================================="
echo "    IronHome iOS - Sideloadable IPA Builder      "
echo "=================================================="

PROJECT_NAME="IronHome"
SCHEME="IronHome"
BUILD_DIR="./build"
ARCHIVE_PATH="${BUILD_DIR}/${PROJECT_NAME}.xcarchive"
PAYLOAD_DIR="${BUILD_DIR}/Payload"
IPA_PATH="${BUILD_DIR}/${PROJECT_NAME}.ipa"

# 1. Clean previous builds
echo "[1/4] Cleaning previous build artifacts..."
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# 2. Build Release Archive with codesigning bypassed
echo "[2/4] Compiling release archive via xcodebuild..."
xcodebuild archive \
  -project "${PROJECT_NAME}.xcodeproj" \
  -scheme "${SCHEME}" \
  -configuration Release \
  -archivePath "${ARCHIVE_PATH}" \
  -destination "generic/platform=iOS" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  AD_HOC_CODE_SIGNING_ALLOWED=YES

# 3. Create Payload directory and copy .app
echo "[3/4] Packaging Payload structure..."
mkdir -p "${PAYLOAD_DIR}"
cp -R "${ARCHIVE_PATH}/Products/Applications/${PROJECT_NAME}.app" "${PAYLOAD_DIR}/"

# 4. Zip Payload into .ipa
echo "[4/4] Generating ${PROJECT_NAME}.ipa..."
cd "${BUILD_DIR}"
zip -r -q "${PROJECT_NAME}.ipa" "Payload"
cd ..

if [ -f "${IPA_PATH}" ]; then
  echo ""
  echo "SUCCESS! Sideloadable IPA ready at:"
  echo "-> $(pwd)/${IPA_PATH}"
  echo ""
  echo "Next steps for Sideloadly:"
  echo "1. Connect your iPhone via USB/Wi-Fi to your PC or Mac."
  echo "2. Open Sideloadly and drag & drop '${PROJECT_NAME}.ipa' into it."
  echo "3. Enter your Apple ID and click 'Start'."
  echo "4. On iPhone, go to Settings -> General -> VPN & Device Management and Trust the developer profile."
  echo "5. Open IronHome and start your Day 1 Upper A workout!"
else
  echo "ERROR: Failed to package IPA."
  exit 1
fi
