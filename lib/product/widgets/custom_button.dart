// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.text, required this.onPressed, super.key});
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(context.padding.normal),
        elevation: WidgetStateProperty.all<double>(2),
        backgroundColor: WidgetStateProperty.all<Color>(ColorConstants.primaryBlueColor),
        shadowColor: WidgetStateProperty.all<Color>(ColorConstants.primaryBlueColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: ColorConstants.primaryBlueColor.withOpacity(.5)),
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          text,
          style: context.general.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstants.whiteColor,
          ),
        ),
      ),
    );
  }
}
