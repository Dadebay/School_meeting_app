import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/widgets/custom_button.dart';

@RoutePage()
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _gradientColor(),
          Align(
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              IconConstants.splashLottie,
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              animate: true,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.5,
              margin: context.padding.normal,
              padding: context.padding.medium,
              decoration: BoxDecoration(
                borderRadius: context.border.highBorderRadius,
                color: ColorConstants.whiteColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringConstants.splashTitle,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.blackColor,
                    ),
                  ),
                  Text(
                    StringConstants.splashSubtitle,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.greyColor,
                    ),
                  ),
                  CustomButton(
                    text: StringConstants.splashButton,
                    onPressed: () {
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

  Positioned _gradientColor() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorConstants.whiteColor,
              ColorConstants.primaryBlueColor,
            ],
            stops: [0, 0.5],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
