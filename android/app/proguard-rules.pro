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

# Dio HTTP client
-keep class dio.** { *; }
-dontwarn dio.**

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

# Remove logging (optional for production)
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}