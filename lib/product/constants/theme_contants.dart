// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'PlusJakartaSans',
      colorSchemeSeed: ColorConstants.primaryBlueColor,
      useMaterial3: true,
      scaffoldBackgroundColor: ColorConstants.whiteColor,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: ColorConstants.blueColorwithOpacity,
        elevation: 0,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
