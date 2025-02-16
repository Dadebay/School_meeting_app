// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/home/view/home_view.dart';
import 'package:okul_com_tm/feature/profil/view/user_profil.dart';
import 'package:okul_com_tm/product/initialize/custom_bottom_nav_extension.dart';

@RoutePage()
class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> pages = [HomeView(), Container(), UserProfilView()];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: pages[selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
        ));
  }
}
