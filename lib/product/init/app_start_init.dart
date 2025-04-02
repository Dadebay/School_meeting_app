import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/splash/service/notification_service.dart';
import 'package:okul_com_tm/firebase_options.dart';

class HttpOverridesCustom extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  await FCMConfig().sendNotification(body: message.notification!.body!, title: message.notification!.title!);
  return;
}

@immutable
class AppStartInit {
  const AppStartInit._();
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    EasyLocalization.logger.enableLevels = [LevelMessages.error];
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    HttpOverrides.global = HttpOverridesCustom();

//////
    await EasyLocalization.ensureInitialized();
    await DeviceUtility.instance.initPackageInfo();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FCMConfig().requestPermission();
    await FCMConfig().initAwesomeNotification();
    FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  }

  static Future<void> getNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FCMConfig().sendNotification(body: message.notification!.body!, title: message.notification!.title!);
    });
  }
}
