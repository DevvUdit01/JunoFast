import 'package:flutter/material.dart';
import 'package:junofast/Configs/Colors.dart';

var lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,

  // AppBar theme
  appBarTheme: const AppBarTheme(
    color: Colors.orange, // Default app bar color
  ),

  // Full ColorScheme definitions (with 'background' replaced by 'surface')
  colorScheme: ColorScheme.light(
    primary: appBarColor, // Used for the primary elements of your app (e.g., AppBar, buttons).
    onPrimary: appFontColor, // Text/icon color that appears on primary-colored widgets.

    secondary: btnColor, // Color for less prominent elements (e.g., FloatingActionButton, Chips).
    onSecondary: btnTextColor, // Text/icon color that appears on secondary-colored widgets.
    
    surface: bgColor, // Background color for surfaces like cards, containers, scaffold.
    onSurface: fontColor, // Text/icon color that appears on surface backgrounds.

  //  error: errorColor, // Color to represent error states (e.g., form validation errors).
  //  onError: errorTextColor, // Text/icon color that appears on error-colored backgrounds.

    primaryContainer: containerColor, // A variation of the primary color for containers (e.g., cards).
    onPrimaryContainer: containerTextColor, // Text/icon color that appears on primary container backgrounds.

    secondaryContainer: btnColor, // A variation of the secondary color for containers.
    onSecondaryContainer: btnTextColor, // Text/icon color that appears on secondary container backgrounds.

    brightness: Brightness.light, // Defines whether the theme is light or dark.
  ),

  // Text theme definitions
  textTheme: TextTheme(
    // headlineMedium: TextStyle(
    //   fontSize: 34,
    //   fontFamily: "console",
    //   color: fontColor, // General font color
    //   fontWeight: FontWeight.w700, // Bold headline text
    // ),
    bodyLarge: TextStyle(
      fontSize: 18,//24
      fontFamily: "console",
      color: fontColor, // General font color
      fontWeight: FontWeight.w500, // Bold body text
    ),
    // bodyMedium: TextStyle(
    //   fontSize: 20,
    //   fontFamily: "console",
    //   color: fontColor, // General font color
    //   fontWeight: FontWeight.w400, // Normal body text
    // ),
    // labelMedium: const TextStyle(
    //   fontSize: 16,
    //   fontFamily: "console",
    //   color: Colors.red, // Red color for labels (e.g., error messages)
    //   fontWeight: FontWeight.w400, // Normal label text weight
    // ),
  ),
);
