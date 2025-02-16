import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/home/components/calendar_slider.dart';
import 'package:okul_com_tm/feature/home/components/lesson_card.dart';
import 'package:okul_com_tm/feature/home/components/user_image_name_widget.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  final List<Color> lessonCardColors = const [
    ColorConstants.blueColorwithOpacity,
    ColorConstants.purpleColorwithOpacity,
    ColorConstants.greenColorwithOpacity,
    ColorConstants.yellowColorwithOpacity,
  ];
  List<LessonModel> generateLessons() {
    return [
      LessonModel(
        title: 'How to grow your Facebook Page',
        subtitle: 'Follow these easy and simple steps',
        image: 'assets/images/pattern_1.png',
        teacher: 'John Smith',
        time: '10:00 - 11:00',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'Mastering Instagram Marketing',
        subtitle: 'Learn the secrets to Instagram success',
        image: 'assets/images/pattern_2.png', // Başga surat
        teacher: 'Jane Doe',
        time: '11:30 - 12:30',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png', // Başga surat
        teacher: 'David Lee',
        time: '13:00 - 14:00',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'How to grow your Facebook Page',
        subtitle: 'Follow these easy and simple steps',
        image: 'assets/images/pattern_1.png',
        teacher: 'John Smith',
        time: '10:00 - 11:00',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'Mastering Instagram Marketing',
        subtitle: 'Learn the secrets to Instagram success',
        image: 'assets/images/pattern_2.png', // Başga surat
        teacher: 'Jane Doe',
        time: '11:30 - 12:30',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png', // Başga surat
        teacher: 'David Lee',
        time: '13:00 - 14:00',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'How to grow your Facebook Page',
        subtitle: 'Follow these easy and simple steps',
        image: 'assets/images/pattern_1.png',
        teacher: 'John Smith',
        time: '10:00 - 11:00',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'Mastering Instagram Marketing',
        subtitle: 'Learn the secrets to Instagram success',
        image: 'assets/images/pattern_2.png', // Başga surat
        teacher: 'Jane Doe',
        time: '11:30 - 12:30',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png', // Başga surat
        teacher: 'David Lee',
        time: '13:00 - 14:00',
        date: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking 4',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png', // Başga surat
        teacher: 'David Lee',
        time: '13:00 - 14:00',
        date: DateTime.now().day.toString(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: NestedScrollView(
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
            final color = lessonCardColors[index % lessonCardColors.length];
            return LessonCard(
              color: color,
              lessonModel: generateLessons()[index],
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
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
