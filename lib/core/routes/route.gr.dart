// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;
import 'package:okul_com_tm/feature/home/view/bottom_nav_bar_view.dart' as _i1;
import 'package:okul_com_tm/feature/home/view/home_view.dart' as _i5;
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart'
    as _i16;
import 'package:okul_com_tm/feature/lesson_profil/view/lessons_profil.dart'
    as _i6;
import 'package:okul_com_tm/feature/lesson_profil/view/student_attendence_view.dart'
    as _i11;
import 'package:okul_com_tm/feature/login/view/login_view.dart' as _i7;
import 'package:okul_com_tm/feature/news_view/model/news_model.dart' as _i15;
import 'package:okul_com_tm/feature/news_view/view/news_profile_view.dart'
    as _i8;
import 'package:okul_com_tm/feature/news_view/view/news_view.dart' as _i9;
import 'package:okul_com_tm/feature/profil/view/edit_user_profile_view.dart'
    as _i3;
import 'package:okul_com_tm/feature/profil/view/free_time_managament_view.dart'
    as _i4;
import 'package:okul_com_tm/feature/profil/view/user_profil_view.dart' as _i12;
import 'package:okul_com_tm/feature/splash/view/connection_check_view.dart'
    as _i2;
import 'package:okul_com_tm/feature/splash/view/splash_view.dart' as _i10;

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
/// [_i3.EditUserProfileView]
class EditUserProfileView extends _i13.PageRouteInfo<void> {
  const EditUserProfileView({List<_i13.PageRouteInfo>? children})
      : super(
          EditUserProfileView.name,
          initialChildren: children,
        );

  static const String name = 'EditUserProfileView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return _i3.EditUserProfileView();
    },
  );
}

/// generated route for
/// [_i4.FreeTimeManagamentView]
class FreeTimeManagamentView extends _i13.PageRouteInfo<void> {
  const FreeTimeManagamentView({List<_i13.PageRouteInfo>? children})
      : super(
          FreeTimeManagamentView.name,
          initialChildren: children,
        );

  static const String name = 'FreeTimeManagamentView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i4.FreeTimeManagamentView();
    },
  );
}

/// generated route for
/// [_i5.HomeView]
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
      return _i5.HomeView(isTeacher: args.isTeacher);
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
/// [_i6.LessonsProfil]
class LessonsProfil extends _i13.PageRouteInfo<LessonsProfilArgs> {
  LessonsProfil({
    required bool isTeacher,
    required int lessonID,
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          LessonsProfil.name,
          args: LessonsProfilArgs(
            isTeacher: isTeacher,
            lessonID: lessonID,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'LessonsProfil';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LessonsProfilArgs>();
      return _i6.LessonsProfil(
        args.isTeacher,
        args.lessonID,
        key: args.key,
      );
    },
  );
}

class LessonsProfilArgs {
  const LessonsProfilArgs({
    required this.isTeacher,
    required this.lessonID,
    this.key,
  });

  final bool isTeacher;

  final int lessonID;

  final _i14.Key? key;

  @override
  String toString() {
    return 'LessonsProfilArgs{isTeacher: $isTeacher, lessonID: $lessonID, key: $key}';
  }
}

/// generated route for
/// [_i7.LoginView]
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
      return _i7.LoginView();
    },
  );
}

/// generated route for
/// [_i8.NewsProfileView]
class NewsProfileView extends _i13.PageRouteInfo<NewsProfileViewArgs> {
  NewsProfileView({
    _i14.Key? key,
    required _i15.NewsModel newsModel,
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
      return _i8.NewsProfileView(
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

  final _i14.Key? key;

  final _i15.NewsModel newsModel;

  @override
  String toString() {
    return 'NewsProfileViewArgs{key: $key, newsModel: $newsModel}';
  }
}

/// generated route for
/// [_i9.NewsView]
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
      return _i9.NewsView();
    },
  );
}

/// generated route for
/// [_i10.SplashView]
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
      return const _i10.SplashView();
    },
  );
}

/// generated route for
/// [_i11.StudentAttendancePageView]
class StudentAttendanceRouteView
    extends _i13.PageRouteInfo<StudentAttendanceRouteViewArgs> {
  StudentAttendanceRouteView({
    _i14.Key? key,
    required _i16.LessonModel lessonModel,
    required bool showAttendentStudents,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          StudentAttendanceRouteView.name,
          args: StudentAttendanceRouteViewArgs(
            key: key,
            lessonModel: lessonModel,
            showAttendentStudents: showAttendentStudents,
          ),
          initialChildren: children,
        );

  static const String name = 'StudentAttendanceRouteView';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StudentAttendanceRouteViewArgs>();
      return _i11.StudentAttendancePageView(
        key: args.key,
        lessonModel: args.lessonModel,
        showAttendentStudents: args.showAttendentStudents,
      );
    },
  );
}

class StudentAttendanceRouteViewArgs {
  const StudentAttendanceRouteViewArgs({
    this.key,
    required this.lessonModel,
    required this.showAttendentStudents,
  });

  final _i14.Key? key;

  final _i16.LessonModel lessonModel;

  final bool showAttendentStudents;

  @override
  String toString() {
    return 'StudentAttendanceRouteViewArgs{key: $key, lessonModel: $lessonModel, showAttendentStudents: $showAttendentStudents}';
  }
}

/// generated route for
/// [_i12.UserProfilView]
class UserProfilView extends _i13.PageRouteInfo<UserProfilViewArgs> {
  UserProfilView({
    _i14.Key? key,
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
      return _i12.UserProfilView(
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

  final _i14.Key? key;

  final bool isTeacher;

  @override
  String toString() {
    return 'UserProfilViewArgs{key: $key, isTeacher: $isTeacher}';
  }
}
