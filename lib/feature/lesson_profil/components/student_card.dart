import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lessons_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class StudentCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentList = ref.watch(studentProvider);
    print(studentList);
    return Container(
      padding: context.padding.low,
      margin: context.padding.onlyBottomHigh,
      decoration: BoxDecoration(
        borderRadius: context.border.highBorderRadius,
        color: ColorConstants.greyColorwithOpacity,
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1.3,
        ),
        itemCount: studentList.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final studentModel = studentList[index];
          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: context.padding.normal,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorConstants.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: ApiConstants.imageURL + studentModel.img,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider),
                      ),
                    ),
                    placeholder: (context, url) => CustomWidgets.loader(),
                    errorWidget: (context, url, error) => CustomWidgets.imagePlaceHolder(),
                  ),
                ),
              ),
              Text(
                studentModel.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstants.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
