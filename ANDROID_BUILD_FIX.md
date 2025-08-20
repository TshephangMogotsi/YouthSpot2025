# Android Build Configuration Fix

## Issue Resolution: Flutter.minSdkVersion Error

### Problem Description
Users experiencing the following error when building the Flutter Android app:
```
e: file:///path/to/android/app/build.gradle.kts:33:30: Expecting an element
e: file:///path/to/android/app/build.gradle.kts:33:9: Function invocation 'minSdkVersion(...)' expected
```

### Root Cause
The error occurs when:
1. The `android/local.properties` file is missing
2. Flutter properties cannot be resolved during the Gradle build process

### Solution Applied

#### 1. Created Missing local.properties File
Created `android/local.properties` with proper Flutter and Android SDK path configuration:
```properties
# This file contains local development configuration.
# Android SDK path (adjust to your local installation)
sdk.dir=${ANDROID_HOME:-/usr/lib/android-sdk}

# Flutter SDK path (adjust to your local installation)  
flutter.sdk=${FLUTTER_ROOT:-/usr/local/flutter}
```

#### 2. Verified build.gradle.kts Syntax
Confirmed that `android/app/build.gradle.kts` uses correct Kotlin DSL syntax:
- ✅ `minSdk = 23` (correct)
- ❌ `minSdkVersion flutter.minSdkVersion` (old syntax that causes errors)

#### 3. Build Configuration Verified
- minSdk: 23 (Android 6.0)
- targetSdk: 34 (Android 14)
- compileSdk: 35 (Latest)

### Files Modified
- `android/local.properties` (created)
- `fix_android_build.sh` (added troubleshooting script)

### For Developers

#### Setup Instructions
1. Ensure you have Flutter installed and in your PATH
2. Copy `android/local.properties.template` to `android/local.properties`
3. Update `android/local.properties` with your local SDK paths:
   ```properties
   sdk.dir=/path/to/your/android-sdk
   flutter.sdk=/path/to/your/flutter-sdk
   ```
4. Run the following commands:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

#### Troubleshooting
If you encounter build issues:
1. Run the provided troubleshooting script: `./fix_android_build.sh`
2. Check that your local.properties paths are correct
3. Ensure Flutter SDK version compatibility
4. Verify Android SDK components are installed

### Prevention
- The `local.properties` file is automatically excluded from version control (in `.gitignore`)
- Each developer needs to configure their own local paths
- The build.gradle.kts file uses hardcoded values to avoid dependency on Flutter properties

### Related Issues
This fix addresses:
- Missing Flutter SDK configuration
- Gradle build failures related to minSdkVersion
- Environment setup issues for new developers