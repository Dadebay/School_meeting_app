// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.text, required this.onPressed, super.key, this.mini, this.removeShadow, this.showBorderStyle});
  final String text;
  final bool? mini;
  final bool? removeShadow;
  final bool? showBorderStyle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: mini == true ? WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13, horizontal: 15)) : WidgetStateProperty.all<EdgeInsetsGeometry>(context.padding.normal),
        elevation: WidgetStateProperty.all<double>(2),
        backgroundColor: showBorderStyle == true ? WidgetStateProperty.all<Color>(Colors.transparent) : WidgetStateProperty.all<Color>(ColorConstants.primaryBlueColor),
        shadowColor: showBorderStyle == true || removeShadow == true ? WidgetStateProperty.all<Color>(Colors.transparent) : WidgetStateProperty.all<Color>(ColorConstants.primaryBlueColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: showBorderStyle == true ? ColorConstants.primaryBlueColor : ColorConstants.primaryBlueColor.withOpacity(.5)),
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
            color: showBorderStyle == true ? ColorConstants.blackColor : ColorConstants.whiteColor,
          ),
        ).tr(),
      ),
    );
  }
}
