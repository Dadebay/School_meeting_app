import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/news_view/model/news_model.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/constants/string_constants.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

@RoutePage()
class NewsProfileView extends StatelessWidget {
  final NewsModel newsModel;
  const NewsProfileView({super.key, required this.newsModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstants.primaryBlueColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              IconlyLight.arrow_left_circle,
              color: ColorConstants.whiteColor,
            )),
        title: Text(
          StringConstants.news,
          style: context.general.textTheme.headlineMedium!.copyWith(color: ColorConstants.whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: newsModel.title,
              child: CustomWidgets.imageWidget(newsModel.img),
            ),
            Padding(
              padding: context.padding.normal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsModel.title,
                    style: context.general.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    newsModel.date,
                    style: context.general.textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    newsModel.content,
                    style: context.general.textTheme.bodyLarge,
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
