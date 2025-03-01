// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/home/view/home_view.dart';
import 'package:okul_com_tm/feature/profil/view/user_profil.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/initialize/custom_bottom_nav_extension.dart';

import '../../news_view/view/news_view.dart';

@RoutePage()
class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  List<IconData> studentIcons = [IconlyLight.home, IconlyLight.discovery, IconlyLight.profile];
  List<IconData> studentSelectedIcons = [IconlyBold.home, IconlyBold.discovery, IconlyBold.profile];
  final List<Widget> pages = [HomeView(), NewsView(), UserProfilView(isTeacher: false)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: selectedIndex == 1
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ColorConstants.primaryBlueColor,
                title: Text(
                  StringConstants.news,
                  style: context.general.textTheme.headlineMedium!.copyWith(color: ColorConstants.whiteColor, fontWeight: FontWeight.bold),
                ),
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
