import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/home/service/calendar_provider.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';

import '../../../product/widgets/index.dart';
import '../../lesson_profil/service/lessons_service.dart';

class CalendarSlider extends ConsumerWidget {
  const CalendarSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(calendarProvider);
    final pageController = ref.watch(pageControllerProvider);

    return Container(
      height: WidgetSizes.calendarSliderWidth.value + 10,
      margin: context.padding.verticalLow,
      child: PageView.builder(
        controller: pageController,
        itemCount: 365, // Tüm yılın günleri
        onPageChanged: (index) {
          final date = getDateFromIndex(index, selectedDate.year);
          ref.read(calendarProvider.notifier).updateSelectedDate(date);
          ref.read(lessonProvider.notifier).fetchLessonsForDate(date);
        },
        itemBuilder: (context, index) {
          final date = getDateFromIndex(index, selectedDate.year);
          final isSelected = selectedDate.day == date.day && selectedDate.month == date.month;

          return GestureDetector(
            onTap: () {
              ref.read(calendarProvider.notifier).updateSelectedDate(date);
              pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              ref.read(lessonProvider.notifier).fetchLessonsForDate(date);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: context.padding.low,
              decoration: BoxDecoration(
                color: isSelected ? ColorConstants.primaryBlueColor : ColorConstants.greyColorwithOpacity,
                borderRadius: context.border.normalBorderRadius,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: ColorConstants.primaryBlueColor.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 3,
                        ),
                      ]
                    : [],
                border: Border.all(color: ColorConstants.primaryBlueColor.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: isSelected ? context.general.textTheme.headlineMedium?.fontSize : context.general.textTheme.headlineSmall?.fontSize,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
