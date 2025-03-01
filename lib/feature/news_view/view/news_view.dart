import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class NewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('News View')), body: Lottie.asset('assets/lottie/animation.json')
        // FutureBuilder<List<NewsModel>>(
        //   future: NewsService.fetchNews(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CustomWidgets.loader();
        //     } else if (snapshot.hasError) {
        //       return CustomWidgets.errorFetchData();
        //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //       return CustomWidgets.emptyData();
        //     } else {
        //       final newsList = snapshot.data!;
        //       return ListView.builder(
        //         itemCount: newsList.length,
        //         padding: context.padding.onlyTopNormal,
        //         shrinkWrap: true,
        //         physics: BouncingScrollPhysics(),
        //         itemBuilder: (context, index) {
        //           final news = newsList[index];
        //           return NewsCard(newsModel: news);
        //         },
        //       );
        //     }
        //   },
        // ),
        );
  }
}
