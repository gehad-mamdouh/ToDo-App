import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/home/app_colors.dart';

class MyThemeData {
  static final ThemeData lightTheme = ThemeData(
      useMaterial3: false,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundLightColor,
      appBarTheme:
          AppBarTheme(elevation: 0, backgroundColor: AppColors.primaryColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
              side: BorderSide(color: AppColors.whiteColor, width: 4))),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor),
        titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor),
        bodyMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.whiteColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.grayColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      )));

  static final ThemeData darkTheme = ThemeData(
      useMaterial3: false,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundDarkColor,
      appBarTheme:
          AppBarTheme(elevation: 0, backgroundColor: AppColors.blackColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.blackColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
              side: BorderSide(color: AppColors.primaryColor, width: 4))),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor),
        titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor),
        bodyMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.whiteColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.whiteColor,
        backgroundColor: const Color(0xff060E1E),
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      )));
}
