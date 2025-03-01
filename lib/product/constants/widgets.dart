import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class CustomSnackbar {
  static void showCustomSnackbar(BuildContext context, String title, String subtitle, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            if (subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
        duration: const Duration(seconds: 3),
        margin: context.padding.low,
      ),
    );
  }
}
