import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class ColorConstants {
  const ColorConstants._();
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color greyColor = Colors.grey;
  static const Color primaryBlueColor = Color(0xff0067ff);
  static const Color blueColorwithOpacity = Color(0xffcde7fc);
  static const Color greenColor = Color(0xff3ead2c);
  static const Color greenColorwithOpacity = Color(0xff8ed385);
  static const Color greenColorwithOpacity2 = Color(0xffdcffce);
  static const Color yellowColorwithOpacity = Color(0xfffedb00);
  static const Color purpleColor = Color(0xffbf7ef3);
  static const Color purpleColorwithOpacity = Color(0xffe6cefe);
  static const Color greyColorwithOpacity = Color(0xfff2f5fc);
  static const Color redColorwithOpacity = Color(0x00ff7272);
  static const Color redColor = Colors.red;
  static Positioned gradientColor() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorConstants.whiteColor,
              ColorConstants.primaryBlueColor,
            ],
            stops: [0, 0.3],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  static Color getRandomColor() {
    final List<Color> colors = [
      ColorConstants.primaryBlueColor,
      ColorConstants.greenColor,
      ColorConstants.purpleColor,
      ColorConstants.greenColorwithOpacity,
      ColorConstants.yellowColorwithOpacity,
      ColorConstants.purpleColorwithOpacity,
      Colors.orange,
      Colors.deepPurple,
      Colors.purple,
      Colors.yellowAccent,
    ];
    return colors[Random().nextInt(colors.length)];
  }
}
