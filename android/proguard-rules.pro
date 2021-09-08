#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class com.bavagnoli.median_cut.**  { *; }
#-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.**
-dontwarn android.**

-keep class androidx.lifecycle.** { *; } #https://github.com/flutter/flutter/issues/58479
