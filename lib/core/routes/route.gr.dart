// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i15;
import 'package:okul_com_tm/feature/home/model/lesson_model.dart' as _i14;
import 'package:okul_com_tm/feature/home/view/bottom_nav_bar_view.dart' as _i1;
import 'package:okul_com_tm/feature/home/view/home_view.dart' as _i4;
import 'package:okul_com_tm/feature/lesson_profil/view/lessons_profil.dart'
    as _i5;
import 'package:okul_com_tm/feature/lesson_profil/view/student_attendence_view.dart'
    as _i10;
import 'package:okul_com_tm/feature/login/view/login_view.dart' as _i6;
import 'package:okul_com_tm/feature/news_view/model/news_model.dart' as _i16;
import 'package:okul_com_tm/feature/news_view/view/news_profile_view.dart'
    as _i7;
import 'package:okul_com_tm/feature/news_view/view/news_view.dart' as _i8;
import 'package:okul_com_tm/feature/profil/view/free_time_post_page.dart'
    as _i3;
import 'package:okul_com_tm/feature/profil/view/user_profil.dart' as _i11;
import 'package:okul_com_tm/feature/profil/view/user_update_profile.dart'
    as _i12;
import 'package:okul_com_tm/feature/splash/view/connection_check_view.dart'
    as _i2;
import 'package:okul_com_tm/feature/splash/view/splash_view.dart' as _i9;

/// generated route for
/// [_i1.BottomNavBar]
class BottomNavBar extends _i13.PageRouteInfo<void> {
  const BottomNavBar({List<_i13.PageRouteInfo>? children})
      : super(
          BottomNavBar.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavBar';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return _i1.BottomNavBar();
    },
  );
}

/// generated route for
/// [_i2.ConnectionCheckView]
class ConnectionCheckView extends _i13.PageRouteInfo<void> {
  const ConnectionCheckView({List<_i13.PageRouteInfo>? children})
      : super(
          ConnectionCheckView.name,
          initialChildren: children,
        );

  static const String name = 'ConnectionCheckView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.ConnectionCheckView();
    },
  );
}

/// generated route for
/// [_i3.FreeTimePage]
class FreeTimeRoute extends _i13.PageRouteInfo<void> {
  const FreeTimeRoute({List<_i13.PageRouteInfo>? children})
      : super(
          FreeTimeRoute.name,
          initialChildren: children,
        );

  static const String name = 'FreeTimeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i3.FreeTimePage();
    },
  );
}

/// generated route for
/// [_i4.HomeView]
class HomeView extends _i13.PageRouteInfo<HomeViewArgs> {
  HomeView({
    required bool isTeacher,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          HomeView.name,
          args: HomeViewArgs(isTeacher: isTeacher),
          initialChildren: children,
        );

  static const String name = 'HomeView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeViewArgs>();
      return _i4.HomeView(isTeacher: args.isTeacher);
    },
  );
}

class HomeViewArgs {
  const HomeViewArgs({required this.isTeacher});

  final bool isTeacher;

  @override
  String toString() {
    return 'HomeViewArgs{isTeacher: $isTeacher}';
  }
}

/// generated route for
/// [_i5.LessonsProfil]
class LessonsProfil extends _i13.PageRouteInfo<LessonsProfilArgs> {
  LessonsProfil({
    required _i14.LessonModel lessonModel,
    required bool isTeacher,
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          LessonsProfil.name,
          args: LessonsProfilArgs(
            lessonModel: lessonModel,
            isTeacher: isTeacher,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'LessonsProfil';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LessonsProfilArgs>();
      return _i5.LessonsProfil(
        args.lessonModel,
        args.isTeacher,
        key: args.key,
      );
    },
  );
}

class LessonsProfilArgs {
  const LessonsProfilArgs({
    required this.lessonModel,
    required this.isTeacher,
    this.key,
  });

  final _i14.LessonModel lessonModel;

  final bool isTeacher;

  final _i15.Key? key;

  @override
  String toString() {
    return 'LessonsProfilArgs{lessonModel: $lessonModel, isTeacher: $isTeacher, key: $key}';
  }
}

/// generated route for
/// [_i6.LoginView]
class LoginView extends _i13.PageRouteInfo<void> {
  const LoginView({List<_i13.PageRouteInfo>? children})
      : super(
          LoginView.name,
          initialChildren: children,
        );

  static const String name = 'LoginView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return _i6.LoginView();
    },
  );
}

/// generated route for
/// [_i7.NewsProfileView]
class NewsProfileView extends _i13.PageRouteInfo<NewsProfileViewArgs> {
  NewsProfileView({
    _i15.Key? key,
    required _i16.NewsModel newsModel,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          NewsProfileView.name,
          args: NewsProfileViewArgs(
            key: key,
            newsModel: newsModel,
          ),
          initialChildren: children,
        );

  static const String name = 'NewsProfileView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewsProfileViewArgs>();
      return _i7.NewsProfileView(
        key: args.key,
        newsModel: args.newsModel,
      );
    },
  );
}

class NewsProfileViewArgs {
  const NewsProfileViewArgs({
    this.key,
    required this.newsModel,
  });

  final _i15.Key? key;

  final _i16.NewsModel newsModel;

  @override
  String toString() {
    return 'NewsProfileViewArgs{key: $key, newsModel: $newsModel}';
  }
}

/// generated route for
/// [_i8.NewsView]
class NewsView extends _i13.PageRouteInfo<void> {
  const NewsView({List<_i13.PageRouteInfo>? children})
      : super(
          NewsView.name,
          initialChildren: children,
        );

  static const String name = 'NewsView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return _i8.NewsView();
    },
  );
}

/// generated route for
/// [_i9.SplashView]
class SplashView extends _i13.PageRouteInfo<void> {
  const SplashView({List<_i13.PageRouteInfo>? children})
      : super(
          SplashView.name,
          initialChildren: children,
        );

  static const String name = 'SplashView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i9.SplashView();
    },
  );
}

/// generated route for
/// [_i10.StudentAttendancePage]
class StudentAttendanceRoute
    extends _i13.PageRouteInfo<StudentAttendanceRouteArgs> {
  StudentAttendanceRoute({
    _i15.Key? key,
    required List<_i14.StudentModel> students,
    required int lessonId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          StudentAttendanceRoute.name,
          args: StudentAttendanceRouteArgs(
            key: key,
            students: students,
            lessonId: lessonId,
          ),
          initialChildren: children,
        );

  static const String name = 'StudentAttendanceRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StudentAttendanceRouteArgs>();
      return _i10.StudentAttendancePage(
        key: args.key,
        students: args.students,
        lessonId: args.lessonId,
      );
    },
  );
}

class StudentAttendanceRouteArgs {
  const StudentAttendanceRouteArgs({
    this.key,
    required this.students,
    required this.lessonId,
  });

  final _i15.Key? key;

  final List<_i14.StudentModel> students;

  final int lessonId;

  @override
  String toString() {
    return 'StudentAttendanceRouteArgs{key: $key, students: $students, lessonId: $lessonId}';
  }
}

/// generated route for
/// [_i11.UserProfilView]
class UserProfilView extends _i13.PageRouteInfo<UserProfilViewArgs> {
  UserProfilView({
    _i15.Key? key,
    required bool isTeacher,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          UserProfilView.name,
          args: UserProfilViewArgs(
            key: key,
            isTeacher: isTeacher,
          ),
          initialChildren: children,
        );

  static const String name = 'UserProfilView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserProfilViewArgs>();
      return _i11.UserProfilView(
        key: args.key,
        isTeacher: args.isTeacher,
      );
    },
  );
}

class UserProfilViewArgs {
  const UserProfilViewArgs({
    this.key,
    required this.isTeacher,
  });

  final _i15.Key? key;

  final bool isTeacher;

  @override
  String toString() {
    return 'UserProfilViewArgs{key: $key, isTeacher: $isTeacher}';
  }
}

/// generated route for
/// [_i12.UserUpdateProfile]
class UserUpdateProfile extends _i13.PageRouteInfo<void> {
  const UserUpdateProfile({List<_i13.PageRouteInfo>? children})
      : super(
          UserUpdateProfile.name,
          initialChildren: children,
        );

  static const String name = 'UserUpdateProfile';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return _i12.UserUpdateProfile();
    },
  );
}
