import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/home/components/index.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _sliverAppBar(context),
        ];
      },
      body: ListView.builder(
        itemCount: 20,
        shrinkWrap: true,
        padding: context.padding.onlyTopNormal,
        itemExtent: WidgetSizes.lessonCardHeight.value,
        itemBuilder: (context, index) {
          final color = LessonModel.lessonCardColors[index % LessonModel.lessonCardColors.length];
          return LessonCard(
            color: color,
            lessonModel: LessonModel.generateLessons()[index],
          );
        },
      ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      collapsedHeight: WidgetSizes.collapsedSliverAppBar.value,
      expandedHeight: WidgetSizes.sliverAppBarHeight.value,
      toolbarHeight: WidgetSizes.collapsedSliverAppBar.value,
      elevation: 5,
      scrolledUnderElevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: context.border.highBorderRadius,
      ),
      backgroundColor: ColorConstants.whiteColor,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: context.border.highBorderRadius,
          gradient: const LinearGradient(
            colors: [
              ColorConstants.blueColorwithOpacity,
              ColorConstants.whiteColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: const FlexibleSpaceBar(
          titlePadding: EdgeInsets.zero,
          title: SizedBox.shrink(),
          background: UserNameAndImage(),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(WidgetSizes.calendarSliderWidth.value),
        child: const CalendarSlider(),
      ),
    );
  }
}
