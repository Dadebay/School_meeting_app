import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/feature/splash/service/fcm_provider.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class LoginView extends ConsumerWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final ValueNotifier<bool> hasAgreed = ValueNotifier(false);

  Future<void> showTermsDialog(BuildContext context) async {
    final terms = await rootBundle.loadString('assets/terms.txt');
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Terms & Conditions'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: MarkdownBody(data: terms),
            ),
          ),
          actions: [
            CustomButton(
              text: LocaleKeys.general_agree,
              onPressed: () {
                hasAgreed.value = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: Image.asset(
          IconConstants.peakBackground,
          fit: BoxFit.cover,
        )),
        Center(
          child: SingleChildScrollView(
            child: Container(
              margin: context.padding.medium,
              padding: context.padding.normal,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: context.border.highBorderRadius,
                color: ColorConstants.whiteColor.withOpacity(.8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: Image.asset(
                      IconConstants.logo,
                      width: ImageSizes.high.value,
                    ),
                  ),
                  Text(LocaleKeys.login_subtitle, textAlign: TextAlign.center, style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)).tr(),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: CustomTextField(
                      labelName: LocaleKeys.login_username,
                      controller: userNameController,
                      prefixIcon: IconlyLight.profile,
                      focusNode: userNameFocusNode,
                      requestfocusNode: passwordFocusNode,
                    ),
                  ),
                  CustomTextField(
                    labelName: LocaleKeys.login_parol,
                    controller: passwordController,
                    prefixIcon: IconlyLight.lock,
                    isPassword: true,
                    focusNode: passwordFocusNode,
                    requestfocusNode: userNameFocusNode,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: CustomButton(
                      text: LocaleKeys.login_log_in,
                      mini: true,
                      removeShadow: true,
                      onPressed: () async {
                        if (!hasAgreed.value) {
                          await showTermsDialog(context);
                          if (!hasAgreed.value) return;
                        }

                        final username = userNameController.text;
                        final password = passwordController.text;
                        await ref.read(authProvider.notifier).login(username, password);
                        if (ref.read(authProvider).isLoggedIn) {
                          await FCMService.postFCMToken();
                          context.router.replaceAll([const ConnectionCheckView()]);
                        } else {
                          userNameController.clear();
                          passwordController.clear();
                          CustomSnackbar.showCustomSnackbar(
                            context,
                            LocaleKeys.errors_title,
                            LocaleKeys.errors_login,
                            ColorConstants.redColor,
                          );
                        }
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () async => await showTermsDialog(context),
                    child: Text(
                      "I agree to the T&C, EULA, and Privacy Policy.",
                      textAlign: TextAlign.center,
                      style: context.general.textTheme.bodyLarge?.copyWith(color: ColorConstants.primaryBlueColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
