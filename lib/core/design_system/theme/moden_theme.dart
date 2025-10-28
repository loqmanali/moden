import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:modn/core/design_system/color_extension/app_color_extension.dart';
import 'package:modn/core/design_system/font_extension/font_extension.dart';

import '../app_colors/app_colors.dart';

/// The ForUI theme
class ModenTheme {
  static FThemeData get light => _lightTheme;
  static FThemeData get dark => _darkTheme;

  static final FThemeData _lightTheme = FThemeData(
    colors: const FColors(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      barrier: Color(0x33000000),
      background: AppColors.background,
      foreground: AppColors.text,
      primary: AppColors.primary,
      primaryForeground: AppColors.background,
      secondary: AppColors.surface,
      secondaryForeground: AppColors.text,
      muted: AppColors.surface,
      mutedForeground: AppColors.textSecondary,
      destructive: AppColors.error,
      destructiveForeground: AppColors.background,
      error: AppColors.error,
      errorForeground: AppColors.background,
      border: AppColors.borderColor,
    ),
    typography: const FTypography(
      base: TextStyle(
        color: AppColors.text,
        fontFamily: 'Inter',
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      lg: TextStyle(
        color: AppColors.text,
        fontFamily: 'Inter',
        fontSize: 18,
        height: 1.75,
        fontWeight: FontWeight.w500,
      ),
      xl: TextStyle(
        color: AppColors.text,
        fontFamily: 'Inter',
        fontSize: 20,
        height: 1.75,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final FThemeData _darkTheme = FThemeData(
    colors: const FColors(
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      barrier: Color(0x66FFFFFF),
      background: AppColors.backgroundDark,
      foreground: AppColors.textDark,
      primary: AppColors.primary,
      primaryForeground: AppColors.backgroundDark,
      secondary: AppColors.surfaceDark,
      secondaryForeground: AppColors.textDark,
      muted: AppColors.surfaceDark,
      mutedForeground: AppColors.textSecondary,
      destructive: AppColors.error,
      destructiveForeground: AppColors.backgroundDark,
      error: AppColors.error,
      errorForeground: AppColors.backgroundDark,
      border: AppColors.borderColor,
    ),
    typography: const FTypography(
      base: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      lg: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontSize: 18,
        height: 1.75,
        fontWeight: FontWeight.w500,
      ),
      xl: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontSize: 20,
        height: 1.75,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static ThemeData lightEx() => light.toApproximateMaterialTheme().copyWith(
        extensions: const [
          AppColorExtension(
            textPrimary: AppColors.textPrimary,
            textTertiary: AppColors.textTertiary,
            surfaceCard: AppColors.surfaceCard,
            textHighlightBlue: AppColors.textHighlightBlue,
            surface: AppColors.surface,
            inactiveButton: AppColors.inactiveButton,
            activeButton: AppColors.activeButton,
            textWhite: AppColors.textWhite,
            iconRed: AppColors.iconRed,
            iconBlue: AppColors.iconBlue,
            buttonTertiary: AppColors.buttonTertiary,
            buttonSecondary: AppColors.buttonSecondary,
          ),
          AppFontThemeExtension(
            headerLarger: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            headerSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            subHeader: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
            bodyMedium: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );

  static ThemeData darkEx() => dark.toApproximateMaterialTheme().copyWith(
        extensions: const [
          AppColorExtension(
            textPrimary: AppColors.textWhite,
            textTertiary: AppColors.textTertiary,
            surfaceCard: AppColors.buttonSecondary,
            textHighlightBlue: AppColors.activeButtonDark,
            surface: AppColors.textPrimary,
            inactiveButton: AppColors.inactiveButton,
            activeButton: AppColors.activeButtonDark,
            textWhite: AppColors.textPrimary,
            iconRed: AppColors.iconRed,
            iconBlue: AppColors.iconBlue,
            buttonTertiary: AppColors.buttonTertiary,
            buttonSecondary: AppColors.buttonSecondary,
          ),
          AppFontThemeExtension(
            headerLarger: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
            headerSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
            subHeader: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
            bodyMedium: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textWhite,
            ),
          ),
        ],
      );
}

/// Extension for easy access to colors
extension ThemeContext on BuildContext {
  /// Access to ForUI theme
  FThemeData get foruiTheme => FTheme.of(this);

  /// Access to app colors
  AppColors get appColors => AppColors();
}
