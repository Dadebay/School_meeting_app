import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:okul_com_tm/feature/profil/service/teacher_lessons_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key, required this.privacyPolicy});
  final bool privacyPolicy;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: privacyPolicy ? 'privacy_policy' : 'about_us', showBackButton: true),
        body: FutureBuilder<String>(
            future: TeacherLessonsService.fetchData(privacy: privacyPolicy),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomWidgets.loader();
              } else if (snapshot.hasError) {
                return CustomWidgets.errorFetchData();
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return CustomWidgets.emptyData();
              } else {
                return ListView(
                  padding: context.padding.low,
                  children: [
                    Html(
                      data: snapshot.data,
                      style: {
                        "body": Style(
                          fontSize: FontSize(18.0),
                          color: Colors.black87,
                          lineHeight: LineHeight(1.5),
                        ),
                        "p": Style(
                          margin: Margins.only(bottom: 12.0),
                        ),
                        "strong": Style(
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.blackColor,
                        ),
                      },
                    ),
                  ],
                );
              }
            }));
  }
}
