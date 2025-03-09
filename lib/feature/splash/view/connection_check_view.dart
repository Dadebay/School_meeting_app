// ignore_for_file: file_names, always_use_package_imports, inference_failure_on_instance_creation

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/constants/icon_constants.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/sizes/image_sizes.dart';

@RoutePage()
class ConnectionCheckView extends ConsumerStatefulWidget {
  const ConnectionCheckView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConnectionCheckViewState();
}

class _ConnectionCheckViewState extends ConsumerState<ConnectionCheckView> {
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        final isFirstLaunch = await ref.read(isFirstLaunchProvider.future);
        final isLoggedIn = await ref.read(authServiceProvider.future);

        if (isFirstLaunch) {
          context.router.replaceNamed('/splash');
        } else if (!isLoggedIn) {
          context.router.replaceNamed('/login');
        } else {
          context.router.replaceNamed('/bottomNavBar');
        }
      }
    } on SocketException catch (_) {
      Dialogs.showNoConnectionDialog(onRetry: () {}, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ClipRRect(
                borderRadius: context.border.highBorderRadius,
                child: Image.asset(
                  IconConstants.logo,
                  width: ImageSizes.high.value,
                  height: ImageSizes.high.value,
                ),
              ),
            ),
          ),
          LinearProgressIndicator(
            color: ColorConstants.primaryBlueColor,
          ),
        ],
      ),
    );
  }
}
