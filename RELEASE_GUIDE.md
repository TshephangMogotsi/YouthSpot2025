# YouthSpot2025 Release Configuration Guide

## Critical Configuration Changes Required Before Release

### 1. Change Application Identifiers

**Android:**
- Update `applicationId` in `/android/app/build.gradle.kts` from `com.example.youthspot` to your organization's domain (e.g., `com.yourcompany.youthspot`)
- Update `namespace` in the same file to match

**iOS:**
- Update `PRODUCT_BUNDLE_IDENTIFIER` in `/ios/Runner.xcodeproj/project.pbxproj` from `com.example.youthspot` to your organization's domain

### 2. App Signing Configuration

**Android App Signing:**
1. Generate a signing key:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `android/key.properties` file (use template):
   ```
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD  
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

3. Update `android/app/build.gradle.kts` to use signing config:
   ```kotlin
   val keystoreProperties = Properties()
   val keystorePropertiesFile = rootProject.file("key.properties")
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(FileInputStream(keystorePropertiesFile))
   }

   android {
       signingConfigs {
           create("release") {
               keyAlias = keystoreProperties["keyAlias"] as String
               keyPassword = keystoreProperties["keyPassword"] as String
               storeFile = file(keystoreProperties["storeFile"] as String)
               storePassword = keystoreProperties["storePassword"] as String
           }
       }
       buildTypes {
           release {
               signingConfig = signingConfigs.getByName("release")
               // ... other release configurations
           }
       }
   }
   ```

**iOS App Signing:**
- Configure signing in Xcode with your Apple Developer account
- Set up provisioning profiles for distribution

### 3. App Store Preparation

**Android (Google Play Store):**
- Update app icons if needed
- Prepare store listing (screenshots, descriptions)
- Test on multiple devices and Android versions
- Submit for review following Play Store guidelines

**iOS (Apple App Store):**
- Update app icons if needed  
- Prepare store listing (screenshots, descriptions)
- Test on multiple devices and iOS versions
- Submit for review following App Store guidelines

### 4. Security Checklist

- ✅ Network security configuration added
- ✅ ProGuard rules configured for code obfuscation
- ✅ Proper permissions declared
- ✅ Biometric authentication privacy descriptions added
- ❗ Change default application/bundle identifiers
- ❗ Set up proper app signing
- ❗ Test on physical devices
- ❗ Review and update API endpoints for production

### 5. Testing Checklist

Before release, test:
- [ ] App installs and launches successfully
- [ ] All core features work (authentication, notifications, file downloads)
- [ ] Biometric authentication works on supported devices
- [ ] Network requests work properly
- [ ] App handles permissions correctly
- [ ] No crashes or ANRs
- [ ] Performance is acceptable
- [ ] Works on different screen sizes
- [ ] Works on different OS versions (within supported range)

### 6. App Store Optimization

- Update app name and description for clarity
- Prepare high-quality screenshots
- Create compelling app store description
- Set appropriate age ratings
- Configure app categories correctly

## Notes

- The app is currently configured with example identifiers that MUST be changed
- All sensitive configuration files should be added to .gitignore
- Consider setting up CI/CD for automated builds and deployments
- Monitor app performance after release using Firebase Crashlytics or similar tools