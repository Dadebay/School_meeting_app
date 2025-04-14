// ignore_for_file: file_names, always_use_package_imports, inference_failure_on_instance_creation

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

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
    _performCheck();
  }

  final storage = FlutterSecureStorage();

  Future<void> _performCheck() async {
    final storage = const FlutterSecureStorage();

    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        final isFirstLaunch = await storage.read(key: 'is_first_launch') == null;
        final String? token = await AuthServiceStorage.getToken();
        log('Check Connection: isFirstLaunch=$isFirstLaunch, isLoggedIn=$token');

        if (isFirstLaunch) {
          await storage.write(key: 'is_first_launch', value: 'false');
          context.router.replaceNamed('/splash');
        } else {
          context.router.replaceNamed('/bottomNavBar');
        }
      } else {
        _showNoConnectionDialog();
      }
    } on SocketException catch (_) {
      _showNoConnectionDialog();
    } catch (e) {
      _showNoConnectionDialog();
    }
  }

  void _showNoConnectionDialog() {
    Dialogs.showNoConnectionDialog(
      context: context,
      onRetry: () {
        Navigator.of(context).pop();
        _performCheck();
      },
    );
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
          )
        ],
      ),
    );
  }
}
