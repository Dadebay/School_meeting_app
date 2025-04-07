import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/home/service/calendar_provider.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';

import '../../../product/dialogs/dialogs.dart';
import '../../../product/widgets/index.dart';
import '../../lesson_profil/service/lessons_service.dart';

class CalendarSlider extends ConsumerWidget {
  const CalendarSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(calendarProvider);
    final Size size = MediaQuery.of(context).size;

    final pageController = PageController(initialPage: calculateInitialPage(selectedDate), viewportFraction: size.width > 800 ? 0.2 : 0.3);

    return Container(
      height: WidgetSizes.calendarSliderWidth.value + 10,
      margin: context.padding.verticalLow,
      child: PageView.builder(
        controller: pageController,
        itemCount: 365,
        itemBuilder: (context, index) {
          final date = getDateFromIndex(index, selectedDate.year);
          final isSelected = selectedDate.day == date.day && selectedDate.month == date.month;

          return GestureDetector(
            onTap: () {
              ref.read(calendarProvider.notifier).updateSelectedDate(date);
              pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              ref.read(lessonProvider.notifier).fetchLessonsForDate(date);
            },
            onLongPress: () {
              Dialogs.showCancelLessonDialog(
                  context: context,
                  title: 'Cancel all lessons',
                  subtitle: 'Are you ready to cancel all lessons to this Date ?',
                  cancelText: 'Agree',
                  ontap: () async {
                    LessonNotifier lessonNotifier = ref.read(lessonProvider.notifier);
                    await LessonService.cancelAllLessons(date).then((value) {
                      if (value == 200) {
                        Navigator.of(context).pop();
                        CustomSnackbar.showCustomSnackbar(context, 'Success', 'All lessons canceled', ColorConstants.greenColor);
                        lessonNotifier.clearLessons([]);
                        lessonNotifier.fetchLessonsForDate(date);
                      } else {
                        Navigator.of(context).pop();

                        CustomSnackbar.showCustomSnackbar(context, 'Error', 'Failed to cancel lessons', ColorConstants.redColor);
                      }
                    });
                  });
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
