import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

import '../../../product/dialogs/dialogs.dart';

class ProfilSliverAppBar extends ConsumerWidget {
  const ProfilSliverAppBar({super.key, required this.innerBoxIsScrolled, required this.isTeacher});
  final bool innerBoxIsScrolled;
  final bool isTeacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userUpdateProvider);
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: ImageSizes.bigLlargeMini.value,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: ColorConstants.whiteColor,
      title: innerBoxIsScrolled
          ? Text(
              userModel.username,
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            )
          : null,
      leading: IconButton(
        onPressed: () => context.navigateNamedTo('/updateProfile'),
        icon: Icon(IconlyLight.edit_square, color: ColorConstants.greyColor),
      ),
      actions: [
        Padding(
          padding: context.padding.low,
          child: IconButton(
            onPressed: () => Dialogs.logOut(context: context),
            icon: Icon(IconlyLight.logout, color: ColorConstants.greyColor),
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
              child: CachedNetworkImage(
                imageUrl: ApiConstants.imageURL + userModel.imagePath,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: imageProvider),
                  ),
                ),
                placeholder: (context, url) => CustomWidgets.loader(),
                errorWidget: (context, url, error) => CustomWidgets.imagePlaceHolder(),
              ),
            ),
            Padding(
              padding: context.padding.normal,
              child: Text(
                userModel.username,
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
                    style: context.general.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold, color: ColorConstants.whiteColor),
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
