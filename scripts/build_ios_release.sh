#!/bin/bash
set -euo pipefail

# Ensure the script runs from the project root.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$PROJECT_ROOT"

echo "Running flutter clean..."
flutter clean

echo "Running flutter pub get..."
flutter pub get

echo "Building IPA in release mode..."
flutter build ipa --release

echo "✅ Done: IPA built in release mode."
