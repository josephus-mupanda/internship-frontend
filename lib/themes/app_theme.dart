import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'text_styles.dart';

class AppTheme {

  static final ThemeData lightTheme = ThemeData(
    primaryColor: ColorPalette.primaryColor,
    primaryColorDark: ColorPalette.primaryVariant,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorPalette.primaryColor,
      primary: ColorPalette.primaryColor,
      onPrimary: ColorPalette.onPrimaryColor,
      secondary: ColorPalette.secondaryColor,
      onSecondary: ColorPalette.onSecondaryColor,
      background: ColorPalette.backgroundColor,
      onBackground: ColorPalette.onBackgroundColor,
      error: ColorPalette.errorColor,
      onError: ColorPalette.onErrorColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyles.headline1,
      headlineMedium: TextStyles.headline2,
      bodyLarge: TextStyles.bodyText1,
      bodyMedium: TextStyles.bodyText2,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: ColorPalette.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorPalette.primaryColor,
      titleTextStyle: TextStyle(
        color: ColorPalette.onPrimaryColor,
        fontSize: 20.0,
      ),
    ),
    iconTheme: const IconThemeData(
      color: ColorPalette.primaryColor, // Default icon color for light theme
      size: 24.0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorPalette.primaryColor,
      foregroundColor: ColorPalette.onPrimaryColor,
      elevation: 6.0, // Adjust elevation if needed
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: ColorPalette.primaryColor,
    primaryColorDark: ColorPalette.primaryVariant,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorPalette.primaryColor,
      primary: ColorPalette.primaryColor,
      onPrimary: ColorPalette.onPrimaryColor,
      secondary: ColorPalette.secondaryColor,
      onSecondary: ColorPalette.onSecondaryColor,
      background: ColorPalette.onBackgroundColor, // Use onBackgroundColor for dark
      onBackground: ColorPalette.backgroundColor, // And backgroundColor for onBackground
      error: ColorPalette.errorColor,
      onError: ColorPalette.onErrorColor,
      brightness: Brightness.dark, // Explicitly set brightness for dark theme
    ),
    cardColor: const Color.fromRGBO(45, 47, 60, 1),//Color.fromRGBO(33, 34, 45, 1),//Color.fromRGBO(50, 53, 72, 1),
    textTheme: TextTheme(
      headlineLarge: TextStyles.headline1.copyWith(color: ColorPalette.backgroundColor),
      headlineMedium: TextStyles.headline2.copyWith(color: ColorPalette.backgroundColor),
      bodyLarge: TextStyles.bodyText1.copyWith(color: ColorPalette.backgroundColor),
      bodyMedium: TextStyles.bodyText2.copyWith(color: ColorPalette.backgroundColor),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: ColorPalette.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorPalette.primaryColor,
      titleTextStyle: TextStyle(
        color: ColorPalette.onPrimaryColor,
        fontSize: 20.0,
      ),
    ),
    iconTheme: const IconThemeData(
      color: ColorPalette.onBackgroundColor,
      size: 24.0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorPalette.primaryColor,
      foregroundColor: ColorPalette.onBackgroundColor,
      elevation: 6.0, // Adjust elevation if needed
    ),
  );
}
