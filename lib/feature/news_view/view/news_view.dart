import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/news_view/components/news_card.dart';
import 'package:okul_com_tm/feature/news_view/model/news_model.dart';

@RoutePage()
class NewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: NewsModel.generateNews().length,
      padding: context.padding.onlyTopNormal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final news = NewsModel.generateNews()[index];
        return NewsCard(newsModel: news);
      },
    );
  }
}
