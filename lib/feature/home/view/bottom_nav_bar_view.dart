// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/chat_view/view/chat_view.dart';
import 'package:okul_com_tm/feature/home/view/home_view.dart';
import 'package:okul_com_tm/feature/profil/view/user_profil_view.dart';
import 'package:okul_com_tm/product/init/custom_bottom_nav_extension.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

import '../../news_view/view/news_view.dart';

@RoutePage()
class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isTeacher = false;
  String appleStoreFake = "";
  @override
  void initState() {
    super.initState();

    getUserStatus();
  }

  dynamic getUserStatus() async {
    appleStoreFake = await AuthServiceStorage.getAppleStoreStatus() ?? '';

    await AuthServiceStorage.getStatus().then((value) {
      if (value != null) {
        isTeacher = value == 'teacher';
      } else {
        isTeacher = false;
      }
      setState(() {});
    });
  }

  int selectedIndex = 0;
  List<IconData> studentIcons = [IconlyLight.home, IconlyLight.discovery, IconlyLight.chat, IconlyLight.profile];
  List<IconData> studentSelectedIcons = [IconlyBold.home, IconlyBold.discovery, IconlyBold.chat, IconlyBold.profile];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [HomeView(isTeacher: isTeacher), NewsView(), ChatView(isClosed: appleStoreFake.isEmpty ? false : true), UserProfilView(isTeacher: isTeacher)];

    return Scaffold(
        extendBody: true,
        appBar: selectedIndex == 1
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ColorConstants.primaryBlueColor,
                title: Text(
                  LocaleKeys.lessons_news,
                  style: context.general.textTheme.headlineMedium!.copyWith(color: ColorConstants.whiteColor, fontWeight: FontWeight.bold),
                ).tr(),
              )
            : null,
        body: pages[selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          selectedIcons: studentSelectedIcons,
          unselectedIcons: studentIcons,
          currentIndex: selectedIndex,
          onTap: (index) async {
            selectedIndex = index;

            setState(() {});
          },
        ));
  }
}
