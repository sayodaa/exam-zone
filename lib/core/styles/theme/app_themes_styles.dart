import 'package:flutter/material.dart';
import 'package:graduation/core/styles/styles.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColorsStyles.light.primaryColor,
    scaffoldBackgroundColor: AppColorsStyles.light.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsStyles.light.appBarBackgroundColor,
      foregroundColor: AppColorsStyles.light.textColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsStyles.light.secondaryColor,
        foregroundColor: AppColorsStyles.light.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding,
          vertical: AppColorsStyles.defaultPadding / 2,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColorsStyles.light.containerBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColorsStyles.light.textColor),
      bodyMedium: TextStyle(color: AppColorsStyles.light.textColor),
      titleLarge: TextStyle(color: AppColorsStyles.light.textColor),
    ),
    iconTheme: IconThemeData(color: AppColorsStyles.light.textColor),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColorsStyles.light.accentBlueColor,
      inactiveTrackColor: AppColorsStyles.light.mutedBackgroundColor,
      thumbColor: AppColorsStyles.light.accentBlueColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColorsStyles.light.accentBlueColor,
      linearTrackColor: AppColorsStyles.light.mutedBackgroundColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColorsStyles.dark.primaryColor,
    scaffoldBackgroundColor: AppColorsStyles.dark.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsStyles.dark.appBarBackgroundColor,
      foregroundColor: AppColorsStyles.dark.surfaceColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsStyles.dark.secondaryColor,
        foregroundColor: AppColorsStyles.dark.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppColorsStyles.defaultPadding,
          vertical: AppColorsStyles.defaultPadding / 2,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColorsStyles.dark.containerBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColorsStyles.defaultBorderRadius),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColorsStyles.dark.surfaceColor),
      bodyMedium: TextStyle(color: AppColorsStyles.dark.surfaceColor),
      titleLarge: TextStyle(color: AppColorsStyles.dark.surfaceColor),
    ),
    iconTheme: IconThemeData(color: AppColorsStyles.dark.surfaceColor),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColorsStyles.dark.accentBlueColor,
      inactiveTrackColor: AppColorsStyles.dark.mutedBackgroundColor,
      thumbColor: AppColorsStyles.dark.accentBlueColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColorsStyles.dark.accentBlueColor,
      linearTrackColor: AppColorsStyles.dark.mutedBackgroundColor,
    ),
  );
}