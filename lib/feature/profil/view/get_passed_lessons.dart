import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/home/components/lesson_card.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lessons_service.dart';
import 'package:okul_com_tm/product/widgets/custom_app_bar.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

@RoutePage()
class PassedLessons extends StatelessWidget {
  const PassedLessons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "past_lessons".tr(), showBackButton: true),
      body: FutureBuilder<List<LessonModel>>(
          future: LessonService.fetchPassedStudentLessons(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomWidgets.loader();
            } else if (snapshot.hasError) {
              return CustomWidgets.errorFetchData(context);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return CustomWidgets.emptyData(context);
            } else {
              final lessonsList = snapshot.data!;
              return ListView.builder(
                itemCount: lessonsList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 120),
                itemExtent: MediaQuery.of(context).size.height / 2,
                itemBuilder: (context, index) {
                  final lesson = lessonsList[index];
                  return LessonCard(
                    lessonModel: lesson,
                    isTeacher: false,
                  );
                },
              );
            }
          }),
    );
  }
}
