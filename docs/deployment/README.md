# YouthSpot 2025 - Deployment Guide

This guide provides comprehensive instructions for building, testing, and deploying the YouthSpot 2025 application.

## 📋 Deployment Overview

### Supported Platforms
- **iOS**: iOS 12.0 and above
- **Android**: Android API level 21 (Android 5.0) and above
- **Development**: macOS, Windows, Linux

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 2.19.0 or higher
- Xcode 14+ (for iOS development)
- Android Studio with Android SDK (for Android development)
- Supabase project setup

---

## 🛠️ Development Environment Setup

### 1. Flutter Installation

#### Install Flutter SDK
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### Required Dependencies
```bash
# Install dependencies
flutter pub get

# Verify project setup
flutter analyze
flutter test
```

### 2. Platform-Specific Setup

#### iOS Setup (macOS only)
```bash
# Install Xcode command line tools
xcode-select --install

# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios && pod install
```

#### Android Setup
```bash
# Install Android Studio
# Configure Android SDK and emulator

# Accept Android licenses
flutter doctor --android-licenses
```

### 3. Environment Configuration

#### Environment Variables
Create `.env` file in project root:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

#### Configuration Files
```yaml
# pubspec.yaml dependencies verification
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.9.1
  provider: ^6.1.5
  # ... other dependencies
```

---

## 🏗️ Build Process

### Development Build

#### Debug Build for Testing
```bash
# iOS debug build
flutter build ios --debug

# Android debug build
flutter build apk --debug

# Run on device/emulator
flutter run
```

#### Hot Reload Development
```bash
# Start development server with hot reload
flutter run --hot

# Enable debugging tools
flutter run --debug
```

### Production Build

#### iOS Production Build
```bash
# Clean previous builds
flutter clean
flutter pub get

# Build iOS release
flutter build ios --release

# Archive for App Store
# Open ios/Runner.xcworkspace in Xcode
# Product > Archive
```

#### Android Production Build
```bash
# Clean previous builds
flutter clean
flutter pub get

# Build Android App Bundle (recommended)
flutter build appbundle --release

# Build APK (alternative)
flutter build apk --release --split-per-abi
```

### Build Optimization

#### Performance Optimization
```bash
# Enable tree shaking
flutter build apk --release --tree-shake-icons

# Optimize bundle size
flutter build appbundle --release --obfuscate --split-debug-info=debug-info/
```

#### Security Configuration
```yaml
# android/app/build.gradle
android {
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## 🔧 Testing Strategy

### Unit Testing
```bash
# Run all unit tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Integration Testing
```bash
# Run integration tests
flutter drive --target=test_driver/app.dart

# Test specific features
flutter test integration_test/
```

### Widget Testing
```bash
# Run widget tests
flutter test test/widget_test.dart

# Test with golden files
flutter test --update-goldens
```

### Performance Testing
```bash
# Profile app performance
flutter run --profile

# Analyze bundle size
flutter build apk --analyze-size
```

---

## 🚀 Deployment Environments

### Environment Configuration

#### Development Environment
```yaml
# config/development.yaml
environment: development
api_base_url: https://dev-api.youthspot.com
debug_mode: true
analytics_enabled: false
```

#### Staging Environment
```yaml
# config/staging.yaml
environment: staging
api_base_url: https://staging-api.youthspot.com
debug_mode: false
analytics_enabled: true
```

#### Production Environment
```yaml
# config/production.yaml
environment: production
api_base_url: https://api.youthspot.com
debug_mode: false
analytics_enabled: true
```

### Database Migration

#### Supabase Setup
```sql
-- Run database migrations
-- Execute supabase_events_table.sql in Supabase dashboard

-- Verify table creation
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Set up Row Level Security
ALTER TABLE community_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_attendees ENABLE ROW LEVEL SECURITY;
```

#### Configuration Verification
```bash
# Test Supabase connection
flutter test test/supabase_connection_test.dart

# Verify authentication flow
flutter test test/auth_test.dart
```

---

## 📱 Platform-Specific Deployment

### iOS Deployment

#### App Store Connect Setup
1. **Create App Record**
   - Log into App Store Connect
   - Create new app with bundle ID
   - Configure app information and metadata

2. **Certificates and Provisioning**
   ```bash
   # Generate certificates (if not using Xcode automatic signing)
   # Create App Store distribution certificate
   # Create App Store provisioning profile
   ```

3. **Build and Upload**
   ```bash
   # Archive in Xcode
   # Upload to App Store Connect
   # Submit for review
   ```

#### iOS Configuration
```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for profile pictures</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location access helps find nearby events</string>
<key>NSFaceIDUsageDescription</key>
<string>Use Face ID for secure login</string>
```

### Android Deployment

#### Google Play Console Setup
1. **Create App**
   - Set up Google Play Console account
   - Create new app listing
   - Configure store listing and content rating

2. **App Signing**
   ```bash
   # Generate keystore (if not using Play App Signing)
   keytool -genkey -v -keystore release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
   
   # Configure gradle signing
   # Add keystore info to android/key.properties
   ```

3. **Upload and Release**
   ```bash
   # Upload to Google Play Console
   # Configure release tracks (internal, alpha, beta, production)
   # Submit for review
   ```

#### Android Configuration
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

#### Automated Testing
```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.1'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
```

#### Automated Deployment
```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build apk --release
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
          packageName: com.youthspot.app
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
```

### Build Automation

#### Fastlane Configuration (iOS)
```ruby
# ios/fastlane/Fastfile
platform :ios do
  desc "Build and upload to App Store"
  lane :release do
    build_app(scheme: "Runner")
    upload_to_app_store(
      force: true,
      reject_if_possible: true,
      skip_metadata: false,
      skip_screenshots: false
    )
  end
end
```

#### Gradle Configuration (Android)
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

---

## 📊 Monitoring & Analytics

### Performance Monitoring

#### Firebase Integration
```dart
// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  
  static void logEvent(String name, Map<String, dynamic> parameters) {
    analytics.logEvent(name: name, parameters: parameters);
  }
  
  static void logError(dynamic exception, StackTrace stackTrace) {
    FirebaseCrashlytics.instance.recordError(exception, stackTrace);
  }
}
```

#### Crash Reporting Setup
```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize crash reporting
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  
  runApp(MyApp());
}
```

### Health Checks

#### Application Health Monitoring
```dart
// lib/services/health_service.dart
class HealthService {
  static Future<bool> checkDatabaseConnection() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .limit(1);
      return response.error == null;
    } catch (e) {
      return false;
    }
  }
  
  static Future<Map<String, dynamic>> getHealthStatus() async {
    return {
      'database': await checkDatabaseConnection(),
      'timestamp': DateTime.now().toIso8601String(),
      'version': await PackageInfo.fromPlatform().then((info) => info.version),
    };
  }
}
```

---

## 🔐 Security Considerations

### Code Obfuscation
```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=debug-info/

# iOS obfuscation in Xcode build settings
# Enable "Symbols Hidden by Default"
```

### API Key Security
```dart
// lib/config/env.dart
class Environment {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}
```

### Certificate Pinning
```dart
// lib/services/http_service.dart
class HttpService {
  static final HttpClient client = HttpClient()
    ..badCertificateCallback = (cert, host, port) {
      // Implement certificate pinning
      return cert.sha1.toLowerCase() == expectedCertSha1;
    };
}
```

---

## 📈 Performance Optimization

### Build Optimization
```yaml
# flutter_build.yaml
targets:
  $default:
    builders:
      build_runner|build_runner:
        options:
          delete_conflicting_outputs: true
```

### Asset Optimization
```bash
# Optimize images
flutter packages pub run flutter_launcher_icons:main

# Optimize fonts
flutter packages pub run google_fonts
```

### Bundle Analysis
```bash
# Analyze app size
flutter build apk --analyze-size

# Profile app performance
flutter run --profile --trace-startup
```

---

## 🚨 Rollback Procedures

### Emergency Rollback

#### App Store Rollback
1. **Immediate Action**
   - Contact App Store support for urgent issues
   - Prepare hotfix release immediately
   - Communicate with users through in-app messaging

2. **Version Rollback**
   ```bash
   # Revert to previous version
   git revert <commit-hash>
   
   # Emergency build and deploy
   flutter build ios --release
   # Upload through Xcode
   ```

#### Database Rollback
```sql
-- Create backup before deployment
pg_dump youthspot_production > backup_$(date +%Y%m%d_%H%M%S).sql

-- Rollback procedures
-- Restore from backup if needed
psql youthspot_production < backup_file.sql
```

### Rollback Verification
```bash
# Test rollback success
flutter test
flutter run --release

# Verify database integrity
flutter test test/database_integrity_test.dart
```

---

## 📝 Deployment Checklist

### Pre-Deployment
- [ ] Run full test suite
- [ ] Verify environment configuration
- [ ] Check database migrations
- [ ] Review security settings
- [ ] Test on multiple devices
- [ ] Verify analytics setup
- [ ] Check app store metadata
- [ ] Review privacy policy updates

### During Deployment
- [ ] Monitor deployment process
- [ ] Verify successful upload
- [ ] Check automated tests pass
- [ ] Monitor error rates
- [ ] Verify app store processing
- [ ] Test downloaded app functionality

### Post-Deployment
- [ ] Monitor crash reports
- [ ] Check user feedback
- [ ] Verify analytics data
- [ ] Monitor performance metrics
- [ ] Review app store reviews
- [ ] Document any issues
- [ ] Plan next release cycle

---

*This deployment guide provides comprehensive instructions for successfully building, testing, and deploying YouthSpot 2025 across all supported platforms with proper monitoring and security considerations.*