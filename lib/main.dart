import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okul_com_tm/core/routes/route.dart';
import 'package:okul_com_tm/product/constants/string_constants.dart';
import 'package:okul_com_tm/product/constants/theme_contants.dart';
import 'package:okul_com_tm/product/initialize/app_start_init.dart';

Future<void> main() async {
  await AppStartInit.init();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('tm', 'TM')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  @override
  void initState() {
    super.initState();
    AppStartInit.getNotification();
  }

  @override
  Widget build(BuildContext context) {
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
      routerConfig: _appRouter.config(),
    );
  }
}
