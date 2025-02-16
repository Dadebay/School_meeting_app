// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      IconlyLight.home,
      IconlyLight.discovery,
      IconlyLight.profile,
    ];
    final selectedItem = [
      IconlyBold.home,
      IconlyBold.discovery,
      IconlyBold.profile,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 25, left: 30, right: 30),
      height: WidgetSizes.iconContainerSize.value,
      decoration: BoxDecoration(
        color: ColorConstants.primaryBlueColor,
        borderRadius: context.border.normalBorderRadius,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.blueColorwithOpacity,
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: isSelected ? 0.0 : 1.0, end: isSelected ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              const selectedColor = ColorConstants.whiteColor;
              const unselectedColor = ColorConstants.blueColorwithOpacity;
              return GestureDetector(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? selectedItem[index] : items[index],
                      color: Color.lerp(unselectedColor, selectedColor, value),
                    ),
                    const SizedBox(height: 5),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: isSelected ? 4 : 0,
                      width: 16,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: context.border.normalBorderRadius,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
