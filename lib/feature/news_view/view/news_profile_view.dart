import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/news_view/model/news_model.dart';
import 'package:okul_com_tm/product/sizes/image_sizes.dart';
import 'package:okul_com_tm/product/widgets/custom_app_bar.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

@RoutePage()
class NewsProfileView extends StatelessWidget {
  final NewsModel newsModel;
  const NewsProfileView({super.key, required this.newsModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'news'.tr(), showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: newsModel.title,
              child: Container(height: ImageSizes.high.value, child: CustomWidgets.imageWidget(newsModel.img, false)),
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
