import 'package:flutter/material.dart';

import '../app_colors/app_colors.dart';
import '../color_extension/app_color_extension.dart';
import '../font_extension/font_extension.dart';

class AppTheme {
  static final light = () {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      colorScheme: _lightAppColors.toColorScheme(Brightness.light),
      scaffoldBackgroundColor: _lightAppColors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightAppColors.surface,
      ),
      extensions: [
        _lightAppColors,
        _lightFontTheme,
      ],
    );
  }();

  static final dark = () {
    final defaultTheme = ThemeData.dark();

    return defaultTheme.copyWith(
      colorScheme: _darkAppColors.toColorScheme(Brightness.dark),
      scaffoldBackgroundColor: _darkAppColors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkAppColors.surface,
      ),
      extensions: [
        _darkAppColors,
        _darkFontTheme,
      ],
    );
  }();

  static final _lightFontTheme = AppFontThemeExtension(
    headerLarger: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: _lightAppColors.textPrimary,
    ),
    headerSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: _lightAppColors.textPrimary,
    ),
    subHeader: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _lightAppColors.textTertiary,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: _lightAppColors.textPrimary,
    ),
  );

  static final _darkFontTheme = AppFontThemeExtension(
    headerLarger: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: _darkAppColors.textPrimary,
    ),
    headerSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: _darkAppColors.textPrimary,
    ),
    subHeader: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _darkAppColors.textTertiary,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: _darkAppColors.textPrimary,
    ),
  );

  static const _lightAppColors = AppColorExtension(
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
  );

  static const _darkAppColors = AppColorExtension(
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
  );
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;
}

extension AppThemeExtension on ThemeData {
  AppColorExtension get colors =>
      extension<AppColorExtension>() ?? AppTheme._lightAppColors;

  AppFontThemeExtension get fonts =>
      extension<AppFontThemeExtension>() ?? AppTheme._lightFontTheme;
}
