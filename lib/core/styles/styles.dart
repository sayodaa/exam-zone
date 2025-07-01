import 'package:flutter/material.dart';

abstract class AppColorsStyles {
  static const _LightColors light = _LightColors();
  static const _DarkColors dark = _DarkColors();

  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
}

class _LightColors {
  const _LightColors();

  final Color primaryColor = const Color(0xFF0D47A1);       // Keep: Vibrant dark blue
  final Color secondaryColor = const Color(0xFF1976D2);     // Keep: Vibrant medium blue
  final Color accentColor = const Color(0xFF42A5F5);        // Brighter blue (was 0xFF64B5F6)
  final Color accentBlueColor = const Color(0xFF0288D1);    // More vibrant blue (was 0xFF40C4FF)
  final Color backgroundColor = const Color(0xFFE3F2FD);    // Light blue tint (was 0xFFF5F5F5)
  final Color surfaceColor = const Color(0xFFFFFFFF);       // Keep: White for surfaces
  final Color textColor = const Color(0xFF212121);         // Darker, more vivid black (was 0xFF1B1B1B)
  final Color secondaryTextColor = const Color(0xFF455A64); // Vibrant dark teal (was 0xFF757575)
  final Color errorColor = const Color(0xFFB00020);         // Keep: Vibrant red for errors
  final Color successColor = const Color(0xFF4CAF50);       // Keep: Vibrant green for success
  final Color appBarBackgroundColor = const Color(0xFFBBDEFB); // Light blue for AppBar (was 0xFFFFFFFF)
  final Color containerBackgroundColor = const Color(0xFFB3E5FC); // Light sky blue (was 0xFFE0E0E0)
  final Color mutedTextColor = const Color(0xFF546E7A);     // Vibrant slate blue (was 0xFF9E9E9E)
  final Color mutedBackgroundColor = const Color(0xFFE1F5FE); // Very light blue (was 0xFFE0E0E0)
  final Color extraMutedTextColor = const Color(0xFF78909C); // Lighter slate blue (was 0xFFB0B0B0)
  final Color extraMutedTextColor2 = const Color(0xFF607D8B); // Darker slate blue (was 0xFF757575)
}

class _DarkColors {
  const _DarkColors();

  final Color primaryColor = const Color(0xFF0D47A1);       // أزرق غامق مميز
  final Color secondaryColor = const Color(0xFF1976D2);     // أزرق متوسط
  final Color accentColor = const Color(0xFF64B5F6);        // أزرق فاتح
  final Color accentBlueColor = const Color(0xFF40C4FF);    // أزرق لامع
  final Color backgroundColor = const Color(0xFF121212);    // خلفية داكنة
  final Color surfaceColor = const Color(0xFFFFFFFF);       // للنصوص البيضاء
  final Color textColor = const Color(0xFF1B1B1B);          // نص أسود (للـ light mode أكتر)
  final Color secondaryTextColor = const Color(0xFFA3A8B2); // نص ثانوي
  final Color errorColor = const Color(0xFFB00020);         // أحمر للأخطاء
  final Color successColor = const Color(0xFF4CAF50);       // أخضر للنجاح
  final Color appBarBackgroundColor = const Color(0xFF0E0E12); // خلفية AppBar داكنة
  final Color containerBackgroundColor = const Color(0xFF1E1E24); // خلفية حاويات داكنة
  final Color mutedTextColor = const Color(0xB3FFFFFF);      // نص ثانوي (مشابه لـ white70)
  final Color mutedBackgroundColor = const Color(0x3DFFFFFF); // خلفية خافتة
  final Color extraMutedTextColor = const Color(0x61FFFFFF);  // نص خافت جداً
  final Color extraMutedTextColor2 = const Color(0x8AFFFFFF); // نص خافت (مشابه لـ white54)
}
