import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: context.padding.normal.copyWith(bottom: 0, top: 40),
              child: Text(StringConstants.appName,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: context.general.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryBlueColor,
                  )),
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
                    "splash_title".tr(),
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.blackColor,
                    ),
                  ),
                  Text(
                    'splash_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.greyColor,
                    ),
                  ),
                  CustomButton(
                    text: 'splash_button'.tr(),
                    onPressed: () {
                      context.navigateNamedTo('/login');
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
