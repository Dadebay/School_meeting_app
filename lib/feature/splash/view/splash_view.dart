import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

import '../../../product/init/language/locale_keys.g.dart';

@RoutePage()
class SplashView extends StatefulWidget {
  SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              IconConstants.splashLoad,
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              // animate: true,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: context.padding.normal.copyWith(bottom: 10, top: 50),
              child: Image.asset(IconConstants.appName),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.5,
              margin: context.padding.normal,
              padding: context.padding.medium,
              decoration: BoxDecoration(borderRadius: context.border.highBorderRadius, color: ColorConstants.whiteColor, boxShadow: [
                BoxShadow(
                  color: ColorConstants.primaryBlueColor.withOpacity(.5),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.splash_title.toString(),
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width > 800 ? 30 : 20,
                      color: ColorConstants.blackColor,
                    ),
                  ).tr(),
                  Text(
                    LocaleKeys.splash_subtitle.toString(),
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width > 800 ? 25 : 18,
                      color: ColorConstants.greyColor,
                    ),
                  ).tr(),
                  CustomButton(
                    text: LocaleKeys.splash_button.toString(),
                    onPressed: () async {
                      await storage.write(key: 'is_first_launch', value: 'false');

                      context.navigateNamedTo('/bottomNavBar');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
