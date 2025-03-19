import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/feature/chat_view/service/chat_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class ChatView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: CustomAppBar(title: "Chat", showBackButton: false),
        body: FutureBuilder<List<ChatStudentModel>>(
          future: ChatService.fetchStudents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomWidgets.loader();
            } else if (snapshot.hasError) {
              return CustomWidgets.errorFetchData();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return CustomWidgets.emptyData();
            } else {
              final students = snapshot.data!;
              return ListView.builder(
                itemCount: students.length,
                padding: context.padding.onlyBottomHigh,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final student = students[index];
                  return studentCard(student, context);
                },
              );
            }
          },
        ));
  }

  GestureDetector studentCard(ChatStudentModel student, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: context.padding.normal,
        child: Row(
          children: [
            Container(
              width: ImageSizes.small.value,
              height: ImageSizes.small.value,
              padding: EdgeInsets.all(10),
              margin: context.padding.onlyRightNormal,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: ColorConstants.greyColorwithOpacity, spreadRadius: 3, blurRadius: 3)],
                border: Border.all(color: ColorConstants.blackColor.withOpacity(.2)),
              ),
              child: CustomWidgets.imageWidget(student.img, false),
            ),
            Expanded(
              child: Text(
                student.username,
                textAlign: TextAlign.left,
                style: context.general.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
