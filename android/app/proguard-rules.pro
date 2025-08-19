# Flutter-specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Supabase and related network libraries - Enhanced protection
-keep class com.google.gson.** { *; }
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Supabase Dart client and GoTrue
-keep class ** implements io.supabase.gotrue.** { *; }
-keep class ** implements io.supabase.realtime.** { *; }
-keep class ** implements io.supabase.storage.** { *; }

# HTTP clients used by Supabase
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Dio HTTP client
-keep class dio.** { *; }
-dontwarn dio.**

# JSON serialization
-keepattributes Signature
-keepattributes *Annotation*
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# SQLite
-keep class io.flutter.plugins.sqflite.** { *; }

# Local Auth
-keep class io.flutter.plugins.localauth.** { *; }

# Awesome Notifications
-keep class me.carda.awesome_notifications.** { *; }

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# Device Info Plus
-keep class dev.fluttercommunity.plus.device_info.** { *; }

# Share Plus
-keep class dev.fluttercommunity.plus.share.** { *; }

# URL Launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Path Provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep all model classes (replace with your actual model package if different)
-keep class com.example.youthspot.models.** { *; }

# Keep all annotations
-keepattributes *Annotation*

# Keep line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Google Play Core classes for deferred components
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Flutter deferred components support
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }

# Alternative: If the above doesn't work, uncomment the following lines to ignore the missing classes
# This is safe if your app doesn't use deferred components
# -dontwarn io.flutter.embedding.engine.deferredcomponents.**
# -dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication

# Specific Google Play Core classes that are causing R8 errors
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Network security - prevent stripping of network classes
-keep class java.security.** { *; }
-keep class javax.net.ssl.** { *; }
-keep class javax.security.** { *; }

# Keep debugging classes in release for troubleshooting
-keep class android.util.Log { *; }
-keep class java.util.logging.** { *; }

# Remove logging (optional for production) - COMMENTED OUT to help debug email issue
# -assumenosideeffects class android.util.Log {
#     public static boolean isLoggable(java.lang.String, int);
#     public static int v(...);
#     public static int i(...);
#     public static int w(...);
#     public static int d(...);
#     public static int e(...);
# }