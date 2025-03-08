import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/news_view/components/news_card.dart';
import 'package:okul_com_tm/feature/news_view/model/news_model.dart';
import 'package:okul_com_tm/feature/news_view/service/news_service.dart';

import '../../../product/widgets/widgets.dart';

@RoutePage()
class NewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService.fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomWidgets.loader();
        } else if (snapshot.hasError) {
          return CustomWidgets.errorFetchData();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return CustomWidgets.emptyData();
        } else {
          final newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            padding: context.padding.onlyBottomHigh,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final news = newsList[index];
              return NewsCard(newsModel: news);
            },
          );
        }
      },
    );
  }
}
