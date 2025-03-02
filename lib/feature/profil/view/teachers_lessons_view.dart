import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/home/components/lesson_card.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/feature/profil/service/teacher_lessons_service.dart';
import 'package:okul_com_tm/product/constants/string_constants.dart';
import 'package:okul_com_tm/product/widgets/custom_app_bar.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

@RoutePage()
class TeacherLessonsView extends ConsumerWidget {
  const TeacherLessonsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: CustomAppBar(title: StringConstants.teacherLessons, showBackButton: true),
        body: FutureBuilder<List<LessonModel>>(
          future: TeacherLessonsService.fetchMyLessons(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomWidgets.loader();
            } else if (snapshot.hasError) {
              return CustomWidgets.errorFetchData();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return CustomWidgets.emptyData();
            } else {
              final lessonsList = snapshot.data!;
              return ListView.builder(
                itemCount: lessonsList.length,
                padding: context.padding.onlyTopNormal,
                shrinkWrap: true,
                itemExtent: MediaQuery.of(context).size.height / 2,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final lesson = lessonsList[index];
                  return LessonCard(
                    lessonModel: lesson,
                  );
                },
              );
            }
          },
        ));
  }
}
