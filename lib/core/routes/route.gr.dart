// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:okul_com_tm/feature/home/model/lesson_model.dart' as _i8;
import 'package:okul_com_tm/feature/home/view/bottom_nav_bar_view.dart' as _i1;
import 'package:okul_com_tm/feature/home/view/home_view.dart' as _i2;
import 'package:okul_com_tm/feature/lesson_profil/view/lessons_profil.dart'
    as _i3;
import 'package:okul_com_tm/feature/profil/view/user_profil.dart' as _i5;
import 'package:okul_com_tm/feature/splash/view/splash_view.dart' as _i4;

/// generated route for
/// [_i1.BottomNavBar]
class BottomNavBar extends _i6.PageRouteInfo<BottomNavBarArgs> {
  BottomNavBar({
    _i7.Key? key,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          BottomNavBar.name,
          args: BottomNavBarArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BottomNavBar';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<BottomNavBarArgs>(orElse: () => const BottomNavBarArgs());
      return _i1.BottomNavBar(key: args.key);
    },
  );
}

class BottomNavBarArgs {
  const BottomNavBarArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'BottomNavBarArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.HomeView]
class HomeView extends _i6.PageRouteInfo<void> {
  const HomeView({List<_i6.PageRouteInfo>? children})
      : super(
          HomeView.name,
          initialChildren: children,
        );

  static const String name = 'HomeView';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeView();
    },
  );
}

/// generated route for
/// [_i3.LessonsProfil]
class LessonsProfil extends _i6.PageRouteInfo<LessonsProfilArgs> {
  LessonsProfil({
    _i7.Key? key,
    required _i8.LessonModel lessonModel,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          LessonsProfil.name,
          args: LessonsProfilArgs(
            key: key,
            lessonModel: lessonModel,
          ),
          initialChildren: children,
        );

  static const String name = 'LessonsProfil';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LessonsProfilArgs>();
      return _i3.LessonsProfil(
        key: args.key,
        lessonModel: args.lessonModel,
      );
    },
  );
}

class LessonsProfilArgs {
  const LessonsProfilArgs({
    this.key,
    required this.lessonModel,
  });

  final _i7.Key? key;

  final _i8.LessonModel lessonModel;

  @override
  String toString() {
    return 'LessonsProfilArgs{key: $key, lessonModel: $lessonModel}';
  }
}

/// generated route for
/// [_i4.SplashView]
class SplashView extends _i6.PageRouteInfo<void> {
  const SplashView({List<_i6.PageRouteInfo>? children})
      : super(
          SplashView.name,
          initialChildren: children,
        );

  static const String name = 'SplashView';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SplashView();
    },
  );
}

/// generated route for
/// [_i5.UserProfilView]
class UserProfilView extends _i6.PageRouteInfo<void> {
  const UserProfilView({List<_i6.PageRouteInfo>? children})
      : super(
          UserProfilView.name,
          initialChildren: children,
        );

  static const String name = 'UserProfilView';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.UserProfilView();
    },
  );
}
