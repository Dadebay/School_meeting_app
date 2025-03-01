import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/feature/news_view/model/news_model.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({required this.newsModel, super.key});
  final NewsModel newsModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.navigateTo(NewsProfileView(newsModel: newsModel));
      },
      child: Card(
        margin: context.padding.low,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: newsModel.title,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                child: CustomWidgets.imageWidget(newsModel.img),
              ),
            ),
            Padding(
              padding: context.padding.normal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsModel.title,
                    style: context.general.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    newsModel.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.general.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    newsModel.date,
                    style: context.general.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
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
