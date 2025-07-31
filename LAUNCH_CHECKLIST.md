# YouthSpot2025 Launch Configuration Checklist

## ❗ CRITICAL - Must Change Before Release

### Application Identifiers
- [ ] **Android**: Change `applicationId` in `android/app/build.gradle.kts` from `com.example.youthspot`
- [ ] **Android**: Change `namespace` in `android/app/build.gradle.kts` from `com.example.youthspot`  
- [ ] **iOS**: Change `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj` from `com.example.youthspot`

### App Signing
- [ ] **Android**: Create release keystore file
- [ ] **Android**: Create `android/key.properties` with signing credentials
- [ ] **Android**: Update build.gradle.kts to use release signing config
- [ ] **iOS**: Configure signing in Xcode with Apple Developer account

## ✅ COMPLETED - Configuration Issues Fixed

### Dependencies & Permissions
- [x] Added missing `path_provider` dependency in pubspec.yaml
- [x] Added `INTERNET` permission for Android
- [x] Added biometric authentication permissions (`USE_BIOMETRIC`, `USE_FINGERPRINT`)
- [x] Added iOS biometric authentication privacy descriptions (`NSFaceIDUsageDescription`)

### Security Configuration  
- [x] Created network security configuration for Android
- [x] Added ProGuard rules for code obfuscation in release builds
- [x] Configured release build with minification and resource shrinking
- [x] Updated .gitignore to exclude sensitive signing files

### Build Configuration
- [x] Set explicit targetSdk to 34 (latest) for Android
- [x] Verified notification icons exist in Android resources
- [x] Added network security config reference in AndroidManifest.xml

### Documentation
- [x] Created comprehensive release guide (RELEASE_GUIDE.md)
- [x] Created app signing template (android/key.properties.template)
- [x] Created this configuration checklist

## 🔍 RECOMMENDED - Additional Steps

### Testing
- [ ] Test app on physical Android devices
- [ ] Test app on physical iOS devices  
- [ ] Test biometric authentication functionality
- [ ] Test file download functionality
- [ ] Test notification functionality
- [ ] Test app performance under various conditions

### App Store Preparation
- [ ] Prepare app store screenshots
- [ ] Write app store description and metadata
- [ ] Set appropriate age rating
- [ ] Configure app categories
- [ ] Prepare privacy policy (if required)

### Monitoring & Analytics
- [ ] Consider adding crash reporting (e.g., Firebase Crashlytics)
- [ ] Consider adding analytics (e.g., Firebase Analytics)
- [ ] Set up backend monitoring for Supabase

## 📋 Current App Configuration Summary

**App Name**: YouthSpot / youthspot
**Version**: 1.0.0+1
**Min SDK**: Android 23 (Android 6.0), iOS 12.0
**Target SDK**: Android 34 (Android 14)
**Main Features**: 
- Supabase backend integration
- Biometric authentication  
- Local database (SQLite)
- Push notifications
- File downloading
- Maps integration
- Social sharing

**Key Dependencies**:
- supabase_flutter: Backend services
- local_auth: Biometric authentication
- awesome_notifications: Push notifications
- permission_handler: Runtime permissions
- sqflite: Local database
- dio: HTTP client

## ⚠️ Known Issues to Address

1. **Application ID**: Still using example domains - MUST change before release
2. **Signing**: Still using debug signing for release builds - MUST configure proper signing
3. **Testing**: Need to test on real devices with various OS versions

## 📞 Final Steps Before Submission

1. Complete all items in the "CRITICAL" section above
2. Thoroughly test the app on multiple devices
3. Review app store guidelines for Android/iOS
4. Prepare all required app store assets
5. Submit for review

---
**Last Updated**: $(date)
**Status**: Ready for final configuration changes