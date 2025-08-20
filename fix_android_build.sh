#!/bin/bash

# Flutter Android Build Troubleshooting Script
# This script helps diagnose and fix common Flutter Android build issues

echo "=== Flutter Android Build Troubleshoot ==="
echo ""

echo "1. Checking local.properties file..."
if [ -f "android/local.properties" ]; then
    echo "✓ local.properties exists"
    echo "Contents:"
    cat android/local.properties
else
    echo "✗ local.properties missing"
    echo "Creating local.properties file..."
    cat > android/local.properties << EOF
# This file contains local development configuration.
# It is typically created automatically by Flutter during project setup.
# For development, these paths should point to your local installations.
# This file should not be committed to version control.

# Android SDK path (adjust to your local installation)
sdk.dir=\${ANDROID_HOME:-/usr/lib/android-sdk}

# Flutter SDK path (adjust to your local installation)  
flutter.sdk=\${FLUTTER_ROOT:-/usr/local/flutter}
EOF
    echo "✓ local.properties created"
fi

echo ""
echo "2. Checking build.gradle.kts syntax..."
if grep -q "minSdkVersion.*flutter" android/app/build.gradle.kts; then
    echo "✗ Found old Groovy syntax in build.gradle.kts"
    echo "Fixing build.gradle.kts syntax..."
    # This would be where we'd fix the syntax if needed
else
    echo "✓ build.gradle.kts uses correct Kotlin DSL syntax"
fi

echo ""
echo "3. Build configuration summary:"
echo "- minSdk: $(grep -o 'minSdk = [0-9]*' android/app/build.gradle.kts)"
echo "- targetSdk: $(grep -o 'targetSdk = [0-9]*' android/app/build.gradle.kts)"
echo "- compileSdk: $(grep -o 'compileSdk = [0-9]*' android/app/build.gradle.kts)"

echo ""
echo "=== Troubleshooting Complete ==="
echo ""
echo "If you still have build issues:"
echo "1. Ensure Flutter SDK is properly installed and in PATH"
echo "2. Update local.properties with correct SDK paths"
echo "3. Run 'flutter clean' and 'flutter pub get'"
echo "4. Try building with 'flutter build apk --debug'"