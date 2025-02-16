// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/home', page: HomeView.page),
        AutoRoute(path: '/bottomNavBar', page: BottomNavBar.page),
        AutoRoute(path: '/lessonProfil', page: LessonsProfil.page),
        AutoRoute(path: '/splash', page: SplashView.page, initial: true),
      ];

  @override
  List<AutoRouteGuard> get guards => [
        // optionally add root guards here
      ];
}
