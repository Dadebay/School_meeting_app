// ignore_for_file: file_names, always_use_package_imports, inference_failure_on_instance_creation

import 'dart:developer';
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
  bool _checkPerformed = false;
  bool _isShowingDialog = false;

  @override
  void initState() {
    super.initState();

    if (!_checkPerformed) {
      _performCheck();
    }
  }

  Future<void> _performCheck() async {
    await AuthNotifier.getAppleStoreStatus();
    if (_checkPerformed || _isShowingDialog) return;
    setState(() {
      _checkPerformed = true;
    });

    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5)); // Zaman aşımı ekle

      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        final isFirstLaunch = await ref.read(isFirstLaunchProvider.future);
        final String? token = await AuthServiceStorage.getToken() ?? '';
        log('Check Connection: isFirstLaunch=$isFirstLaunch, isLoggedIn=$token');
        final String? appleStoreFake = await AuthServiceStorage.getAppleStoreStatus();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (isFirstLaunch) {
            context.router.replaceNamed('/splash');
          } else if (token!.isEmpty && appleStoreFake!.isEmpty) {
            context.router.replaceNamed('/login');
          } else {
            context.router.replaceNamed('/bottomNavBar');
          }
        });
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
    if (!mounted || _isShowingDialog) return;
    setState(() {
      _isShowingDialog = true;
    });

    Dialogs.showNoConnectionDialog(
      context: context,
      onRetry: () {
        Navigator.of(context).pop();
        setState(() {
          _isShowingDialog = false;
          _checkPerformed = false;
        });
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
          if (_checkPerformed && !_isShowingDialog)
            LinearProgressIndicator(
              color: ColorConstants.primaryBlueColor,
            )
          else if (!_checkPerformed)
            LinearProgressIndicator(
              color: ColorConstants.primaryBlueColor,
            ),
        ],
      ),
    );
  }
}
