import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  CustomAppBar({required this.title, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ColorConstants.primaryBlueColor, // Renk sabit olmadığı için ColorConstants'ı manuel değiştirdim.
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                IconlyLight.arrow_left_circle,
                color: ColorConstants.whiteColor,
              ),
            )
          : null,
      title: Text(
        title,
        style: context.general.textTheme.headlineMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
