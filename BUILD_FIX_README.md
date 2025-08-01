# Flutter Release Build Fix

## Issue
The Flutter app was failing to build in release mode with the following error:
```
ERROR: Missing classes detected while running R8. Please add the missing classes or apply additional keep rules
ERROR: R8: Missing class com.google.android.play.core.splitcompat.SplitCompatApplication
```

## Root Cause
R8 (Android's code shrinker) was removing Google Play Core classes that Flutter's deferred components feature references, even though the app doesn't actually use deferred components.

## Solution Applied
Added ProGuard rules in `android/app/proguard-rules.pro` to handle the missing Google Play Core classes:

1. **Keep rules** for Google Play Core classes (if the library is available)
2. **Don't warn rules** for specific missing classes to prevent R8 from failing

## Changes Made

### 1. Updated `android/app/proguard-rules.pro`
Added comprehensive rules to handle Google Play Core classes:
- Keep rules for `com.google.android.play.core.**`
- Don't warn rules for specific missing classes
- Flutter deferred components support rules

### 2. Updated `android/app/build.gradle.kts`
Added Flutter source configuration for proper plugin integration.

## How to Test the Fix
Run the following command to test the release build:
```bash
flutter build apk --release
```

## Alternative Solutions
If the build still fails, you can try:
1. Adding the Google Play Core dependency to `android/app/build.gradle.kts`
2. Completely disabling deferred components in Flutter configuration
3. Using `--no-shrink` flag during build (not recommended for production)

## Files Modified
- `android/app/proguard-rules.pro`
- `android/app/build.gradle.kts`