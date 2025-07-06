// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:okul_com_tm/feature/chat_view/view/chat_view.dart';
import 'package:okul_com_tm/feature/home/view/home_view.dart';
import 'package:okul_com_tm/feature/news_view/view/news_view.dart';
import 'package:okul_com_tm/feature/profil/view/user_profil_view.dart';
import 'package:okul_com_tm/product/init/custom_bottom_nav_extension.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isTeacher = false;
  bool isLoggedIn = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserStatus();
  }

  Future<void> _getUserStatus() async {
    final token = await const FlutterSecureStorage().read(key: 'auth_token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
    await AuthServiceStorage.getStatus().then((value) {
      isTeacher = value == 'teacher';
      setState(() {});
    });
    print(isLoggedIn);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    final List<IconData> unselectedIcons = [
      IconlyLight.home,
      IconlyLight.discovery,
      if (isLoggedIn) IconlyLight.chat,
      IconlyLight.profile,
    ];

    final List<IconData> selectedIcons = [
      IconlyBold.home,
      IconlyBold.discovery,
      if (isLoggedIn) IconlyBold.chat,
      IconlyBold.profile,
    ];

    final List<Widget> pages = [
      HomeView(isTeacher: isTeacher),
      NewsView(),
      if (isLoggedIn) ChatView(),
      UserProfilView(isTeacher: isTeacher, isLoggedIn: isLoggedIn),
    ];

    if (selectedIndex >= pages.length) {
      selectedIndex = 0;
    }

    return Scaffold(
      extendBody: true,
      appBar: selectedIndex == 1
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ColorConstants.primaryBlueColor,
              title: Text(
                LocaleKeys.lessons_news,
                style: context.general.textTheme.headlineMedium!.copyWith(
                  color: ColorConstants.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
            )
          : null,
      body: pages[selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIcons: selectedIcons,
        unselectedIcons: unselectedIcons,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
