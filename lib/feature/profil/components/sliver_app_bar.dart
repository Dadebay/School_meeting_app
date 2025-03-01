import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/sizes/image_sizes.dart';

import '../../../product/dialogs/dialogs.dart';

class ProfilSliverAppBar extends StatelessWidget {
  const ProfilSliverAppBar({super.key, required this.innerBoxIsScrolled, required this.isTeacher});
  final bool innerBoxIsScrolled;
  final bool isTeacher;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: 320,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: ColorConstants.whiteColor,
      title: innerBoxIsScrolled
          ? Text(
              "D.Gurbanov",
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            )
          : null,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          IconlyLight.edit_square,
          color: ColorConstants.greyColor,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Dialogs.logOut(onYestapped: () {}, context: context);
            },
            icon: Icon(
              IconlyLight.logout,
              color: ColorConstants.greyColor,
            ),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: context.padding.normal,
              width: ImageSizes.large.value,
              height: ImageSizes.large.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.primaryBlueColor.withOpacity(.1),
                border: Border.all(color: ColorConstants.blueColorwithOpacity),
              ),
              child: Image.asset(
                IconConstants.user1,
              ),
            ),
            Padding(
              padding: context.padding.normal,
              child: Text(
                "D.Gurbanov",
                style: context.general.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: context.border.normalBorderRadius,
                color: ColorConstants.primaryBlueColor,
              ),
              padding: context.padding.low,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    margin: context.padding.onlyRightLow,
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(color: ColorConstants.whiteColor, shape: BoxShape.circle),
                    child: FittedBox(
                      child: Icon(
                        IconlyBold.profile,
                      ),
                    ),
                  ),
                  Text(
                    isTeacher ? "Teacher" : "Student",
                    style: context.general.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold, color: isTeacher ? ColorConstants.whiteColor : ColorConstants.blackColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
