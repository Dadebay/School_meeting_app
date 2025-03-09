// ignore_for_file: inference_failure_on_function_return_type, inference_failure_on_function_invocation, duplicate_ignore

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class Dialogs {
  static void showNoConnectionDialog({required VoidCallback onRetry, required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı dışarıya tıklayarak kapatamaz.
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.border.normalBorderRadius,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                padding: context.padding.onlyTopNormal,
                child: Container(
                  padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: ColorConstants.whiteColor,
                    borderRadius: context.border.normalBorderRadius,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'noConnectionTitle'.tr(),
                        style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Padding(
                        padding: context.padding.normal,
                        child: Text(
                          'noConnectionSubtitle'.tr(),
                          textAlign: TextAlign.center,
                          style: context.general.textTheme.bodyMedium!.copyWith(fontSize: 19),
                        ),
                      ),
                      CustomButton(
                          text: 'retry'.tr(),
                          onPressed: () {
                            Navigator.of(context).pop(); // Diyalogu kapat.
                            onRetry(); // Yeniden deneme işlemini çağır.
                          }),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: CircleAvatar(
                  backgroundColor: ColorConstants.whiteColor,
                  maxRadius: ImageSizes.small.value,
                  child: ClipOval(
                    child: Image.asset(
                      IconConstants.noConnection,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static showCancelLessonDialog({required BuildContext context, required String title, required String subtitle, required String cancelText, required VoidCallback ontap}) {
    showDialog(
      context: context,
      barrierDismissible: true, // Kullanıcı dışarıya tıklayarak kapatamaz.
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.border.normalBorderRadius,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: context.padding.normal,
            decoration: BoxDecoration(
              color: ColorConstants.whiteColor,
              borderRadius: context.border.normalBorderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyMedium!.copyWith(fontSize: 20),
                  ),
                ),
                CustomButton(text: cancelText, mini: true, onPressed: ontap),
              ],
            ),
          ),
        );
      },
    );
  }

  static logOut({required BuildContext context}) {
    // ignore: inference_failure_on_function_invocation
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        'log_out'.tr(),
                        style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: context.padding.onlyRightLow,
                          child: const Icon(CupertinoIcons.xmark_circle, color: ColorConstants.blackColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: Text(
                    'log_out_title'.tr(),
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.blackColor, fontSize: 19),
                  ),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: CustomButton(
                      text: 'yes'.tr(),
                      mini: true,
                      onPressed: () async {
                        await AuthServiceStorage.clearToken();
                        await AuthServiceStorage.clearStatus();
                        await Restart.restartApp();
                        CustomSnackbar.showCustomSnackbar(context, "success", "log_out_subtitle", ColorConstants.greenColor);
                      },
                      showBorderStyle: true),
                ),
                Padding(
                  padding: context.padding.normal.copyWith(top: 0),
                  child: CustomButton(text: 'no'.tr(), mini: true, onPressed: () => Navigator.of(context).pop(), showBorderStyle: false),
                ),
              ],
            ),
          );
        });
  }
}
