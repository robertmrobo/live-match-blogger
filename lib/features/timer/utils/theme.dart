
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color_scheme.dart';

ThemeData defaultTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ),
  useMaterial3: true,

  // iOS-style background color
  scaffoldBackgroundColor: const Color(0xFFF2F2F7), // iOS system background

  // iOS-style navigation bar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    centerTitle: true, // iOS centers titles
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
  ),

  // iOS-style cards with subtle shadows
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // iOS uses smaller radius
    ),
    elevation: 1,
    shadowColor: Colors.black.withOpacity(0.1),
    surfaceTintColor: Colors.transparent,
    color: Colors.white, // Ensure cards stay white on the new background
  ),

  // iOS-style buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // iOS button radius
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600, // iOS button weight
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
  ),

  // iOS-style text buttons
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),

  // iOS-style filled buttons (for secondary actions)
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.neutral100,
      foregroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
    ),
  ),

  // iOS-style input decoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // Keep inputs white for contrast
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.neutral300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.neutral300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),

  // iOS-style dialogs
  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14), // iOS dialog radius
    ),
    elevation: 10,
    shadowColor: Colors.black.withOpacity(0.3),
    backgroundColor: Colors.white,
    titleTextStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    contentTextStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  ),

  // iOS-style bottom sheets
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    elevation: 10,
  ),

  // iOS-style list tiles
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    tileColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  ),

  // iOS-style dividers
  dividerTheme: DividerThemeData(
    color: AppColors.neutral200,
    thickness: 0.5,
    space: 1,
  ),

  // iOS-style switches and other controls
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      return Colors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return AppColors.neutral300;
    }),
  ),

  // Typography closer to iOS
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
  ),
);

ThemeData darkTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,

  // Dark iOS-style background
  scaffoldBackgroundColor: const Color(0xFF000000), // Pure black for iOS dark mode

  // Dark iOS-style navigation bar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    centerTitle: true,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  ),

  // Dark cards with subtle elevation
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.5),
    surfaceTintColor: Colors.transparent,
    color: AppColors.darkCard, // Dark card background
  ),

  // Dark elevated buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight, // Lighter maroon for dark mode
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
  ),

  // Dark text buttons
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),

  // Dark filled buttons
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.neutral700,
      foregroundColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
    ),
  ),

  // Dark input decoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.neutral800,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.neutral600),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.neutral600),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),

  // Dark dialogs
  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    elevation: 10,
    shadowColor: Colors.black.withOpacity(0.6),
    backgroundColor: AppColors.neutral800,
    titleTextStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    contentTextStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
  ),

  // Dark bottom sheets
  bottomSheetTheme: BottomSheetThemeData(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: AppColors.neutral800,
    elevation: 10,
  ),

  // Dark list tiles
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    tileColor: AppColors.neutral800,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  ),

  // Dark dividers
  dividerTheme: DividerThemeData(
    color: AppColors.neutral600,
    thickness: 0.5,
    space: 1,
  ),

  // Dark switches
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      return AppColors.neutral400;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight;
      }
      return AppColors.neutral700;
    }),
  ),

  // Dark typography
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: Colors.white70,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: Colors.white60,
    ),
  ),
);