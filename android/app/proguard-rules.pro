# Flutter-specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Supabase and related network libraries
-keep class com.google.gson.** { *; }
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Enhanced Supabase auth and HTTP client rules
-keep class io.supabase.gotrue.** { *; }
-keep class io.supabase.realtime.** { *; }
-keep class io.supabase.storage.** { *; }
-dontwarn io.supabase.gotrue.**
-dontwarn io.supabase.realtime.**
-dontwarn io.supabase.storage.**

# Dio HTTP client
-keep class dio.** { *; }
-dontwarn dio.**

# HTTP and networking
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep,allowobfuscation @interface com.google.gson.annotations.SerializedName

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

# Shared Preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep all model classes (replace with your actual model package if different)
-keep class com.example.youthspot.models.** { *; }

# Keep all annotations
-keepattributes *Annotation*

# Keep line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Keep method signatures for reflection
-keepattributes Signature

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

# Network security and SSL
-keep class javax.net.ssl.** { *; }
-keep class org.apache.http.** { *; }
-dontwarn javax.net.ssl.**
-dontwarn org.apache.http.**

# Remove logging (optional for production)
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}