// ignore_for_file: unnecessary_null_comparison

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/custom_icon_button.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/student_card.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/custom_button.dart';

@RoutePage()
class LessonsProfil extends ConsumerStatefulWidget {
  const LessonsProfil(this.lessonModel, {super.key});
  final LessonModel lessonModel;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonsProfilState();
}

class _LessonsProfilState extends ConsumerState<LessonsProfil> {
  String status = "";
  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    final result = await AuthServiceStorage.getStatus();
    if (result != null) {
      status = result;
    } else {
      status = "student"; // Varsayılan bir değer atanabilir.
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(status);
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: status == 'teacher'
          ? widget.lessonModel.teacherConfirmation.toString() == "false"
              ? _floatingActionButton(context)
              : null
          : _floatingActionButton(context),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: ColorConstants.whiteColor,
        scrolledUnderElevation: 0.0,
      ),
      body: ListView(
        padding: context.padding.horizontalNormal,
        physics: BouncingScrollPhysics(),
        children: [
          Text(
            widget.lessonModel.lessonName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.general.textTheme.headlineLarge?.copyWith(
              color: ColorConstants.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: context.padding.onlyTopNormal,
            child: Text(
              "Lesson Status : " + "${widget.lessonModel.teacherConfirmation.toString() == "true" ? "Confirmed" : "Not Confirmed"}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge?.copyWith(
                color: ColorConstants.primaryBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(
              widget.lessonModel.content,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleMedium?.copyWith(
                color: ColorConstants.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          CustomIconButton(lessonModel: widget.lessonModel),
          Padding(
            padding: context.padding.verticalMedium,
            child: Text(
              StringConstants.classmates,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.headlineMedium?.copyWith(
                color: ColorConstants.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StudentCard(
            lessonId: widget.lessonModel.id,
          ),
          SizedBox(
            height: context.padding.verticalHigh.vertical,
          ),
        ],
      ),
    );
  }

  Container _floatingActionButton(BuildContext context) {
    return Container(
      margin: context.padding.normal,
      height: WidgetSizes.iconContainerSize.value,
      child: CustomButton(
        text: status == 'teacher' ? StringConstants.confirm : StringConstants.cancel,
        onPressed: () {
          print(ref.read(authProvider).token);
          if (status == 'teacher') {
          } else {
            Dialogs().showRescheduleDialog(context, ref);
          }
        },
      ),
    );
  }
}
