import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class UserNameAndImage extends ConsumerWidget {
  const UserNameAndImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userUpdateProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateHelper.getFormattedDate(),
                  style: context.general.textTheme.bodyMedium?.copyWith(
                    color: ColorConstants.greyColor,
                  ),
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hey, ',
                        style: context.general.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '${ref.watch(userUpdateProvider).username}!',
                        style: context.general.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 30),
              padding: const EdgeInsets.all(10),
              width: ImageSizes.normal.value,
              height: ImageSizes.normal.value,
              decoration: BoxDecoration(
                borderRadius: context.border.normalBorderRadius,
                color: ColorConstants.primaryBlueColor.withOpacity(.1),
                border: Border.all(color: ColorConstants.primaryBlueColor),
              ),
              child: CustomWidgets.imageWidget(state.imagePath, true)),
        ],
      ),
    );
  }
}
