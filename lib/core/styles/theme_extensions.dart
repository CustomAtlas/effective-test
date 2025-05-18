import 'package:effective_test/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}

extension CustomColorScheme on ColorScheme {
  bool isDarkTheme() => brightness == Brightness.dark;

  Color get scaffold => isDarkTheme() ? AppColors.primaryDark : AppColors.primaryLight;
  Color get invertedScaffold => !isDarkTheme() ? AppColors.primaryDark : AppColors.primaryLight;
  Color get scaffoldSecondary => isDarkTheme() ? AppColors.secondaryDark : AppColors.secondaryLight;
  Color get text => isDarkTheme() ? AppColors.textDark : AppColors.textLight;
  Color get textGray => isDarkTheme() ? AppColors.textGrayDark : AppColors.textGrayLight;
  Color get textSecondaryGray => isDarkTheme() ? AppColors.textSecondaryGrayDark : AppColors.textSecondaryGrayDark;

  Color get commonElement => AppColors.commonElement;
  Color get startNameGradient => AppColors.startNameGradient;
  Color get centerNameGradient => AppColors.centerNameGradient;
  Color get error => AppColors.centerNameGradient;
  Color get endNameGradient => AppColors.endNameGradient;
}
