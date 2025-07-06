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
  final appRouter = AppRouter();
  runApp(
    ProviderScope(
      child: ProductLocalization(
        child: MyApp(appRouter: appRouter),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    doFunction();
  }

  doFunction() async {
    await AppStartInit.setupForegroundNotificationListener();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: StringConstants.appName,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: widget.appRouter.config(),
    );
  }
}
