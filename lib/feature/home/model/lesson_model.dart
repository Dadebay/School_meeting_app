import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class LessonModel {
  LessonModel({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.teacher,
    required this.time,
    required this.date,
    required this.day,
    required this.classLocation,
  });
  static List<Color> lessonCardColors = const [
    ColorConstants.blueColorwithOpacity,
    ColorConstants.greenColorwithOpacity,
    ColorConstants.yellowColorwithOpacity,
    ColorConstants.purpleColorwithOpacity,
  ];
  static List<LessonModel> generateLessons() {
    return [
      LessonModel(
        title: 'How to grow your Facebook Page',
        subtitle: 'Follow these easy and simple steps',
        image: 'assets/images/pattern_1.png',
        teacher: 'John Smith',
        time: '10:00 - 11:00',
        classLocation: 'Room 101', // Class location added
        date: DateHelper.getFormattedDate(),
        day: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'Mastering Instagram Marketing',
        subtitle: 'Learn the secrets to Instagram success',
        image: 'assets/images/pattern_2.png',
        teacher: 'Jane Doe',
        time: '11:30 - 12:30',
        classLocation: 'Room 102', // Class location added
        date: DateHelper.getFormattedDate(),
        day: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png',
        teacher: 'David Lee',
        time: '13:00 - 14:00',
        classLocation: 'Auditorium A', // Class location added
        date: DateHelper.getFormattedDate(),
        day: DateTime.now().day.toString(),
      ),
      LessonModel(
        title: 'How to grow your Facebook Page',
        subtitle: 'Follow these easy and simple steps',
        image: 'assets/images/pattern_1.png',
        teacher: 'John Smith',
        time: '10:00 - 11:00',
        classLocation: 'Room 201',
        day: DateTime.now().day.toString(),
        date: DateHelper.getFormattedDate(),
      ),
      LessonModel(
        title: 'Mastering Instagram Marketing',
        subtitle: 'Learn the secrets to Instagram success',
        image: 'assets/images/pattern_2.png',
        teacher: 'Jane Doe',
        time: '11:30 - 12:30',
        classLocation: 'Room 205',
        day: DateTime.now().day.toString(),
        date: DateHelper.getFormattedDate(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png',
        teacher: 'David Lee',
        time: '13:00 - 14:00',
        classLocation: 'Room 301',
        day: DateTime.now().day.toString(),
        date: DateHelper.getFormattedDate(),
      ),
      LessonModel(
        title: 'How to grow your Facebook Page',
        subtitle: 'Follow these easy and simple steps',
        image: 'assets/images/pattern_1.png',
        teacher: 'John Smith',
        day: DateTime.now().day.toString(),
        time: '10:00 - 11:00',
        classLocation: 'Lab 1',
        date: DateHelper.getFormattedDate(),
      ),
      LessonModel(
        title: 'Mastering Instagram Marketing',
        subtitle: 'Learn the secrets to Instagram success',
        image: 'assets/images/pattern_2.png',
        teacher: 'Jane Doe',
        time: '11:30 - 12:30',
        day: DateTime.now().day.toString(),
        classLocation: "Library",
        date: DateHelper.getFormattedDate(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png',
        teacher: 'David Lee',
        day: DateTime.now().day.toString(),
        time: '13:00 - 14:00',
        classLocation: 'Room 105',
        date: DateHelper.getFormattedDate(),
      ),
      LessonModel(
        title: 'The Art of Public Speaking 4',
        subtitle: 'Become a confident and engaging speaker',
        image: 'assets/images/pattern_3.png',
        teacher: 'David Lee',
        time: '13:00 - 14:00',
        day: DateTime.now().day.toString(),
        classLocation: 'Room 404',
        date: DateHelper.getFormattedDate(),
      ),
    ];
  }

  final String title;
  final String subtitle;
  final String image;
  final String teacher;
  final String time;
  final String date;
  final String day;
  final String classLocation; // Added classLocation
}
