import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okul_com_tm/core/routes/route.dart';
import 'package:okul_com_tm/product/constants/string_constants.dart';
import 'package:okul_com_tm/product/constants/theme_contants.dart';
import 'package:okul_com_tm/product/init/app_start_init.dart';
import 'package:okul_com_tm/product/init/product_localization.dart';

Future<void> main() async {
  await AppStartInit.init();
  runApp(ProviderScope(child: ProductLocalization(child: _MyApp())));
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp.router(
      title: StringConstants.appName,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(1.0),
        ),
        child: child!,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
      // routerDelegate: appRouter.delegate(),
      // routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
