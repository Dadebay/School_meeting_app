import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okul_com_tm/feature/splash/service/notification_service.dart';
import 'package:okul_com_tm/firebase_options.dart';

class HttpOverridesCustom extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  if (message.notification != null && message.notification?.title != null && message.notification?.body != null) {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: 'Notifications received',
            importance: NotificationImportance.Max,
          )
        ],
        debug: false);

    await FCMConfig().sendNotification(body: message.notification!.body!, title: message.notification!.title!);
  } else {
    print("Background message received without notification payload.");
  }
}

@immutable
class AppStartInit {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    EasyLocalization.logger.enableLevels = [LevelMessages.error];
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    HttpOverrides.global = HttpOverridesCustom();

    await EasyLocalization.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FCMConfig().initAwesomeNotification();
    FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
    // --- İZİN İSTEMEYİ GERİ EKLEYİN ---
    await FCMConfig().requestPermission(); // Artık context istemiyor
    // --- İZİN İSTEMEYİ GERİ EKLEYİN ---

    setupForegroundNotificationListener();
  }

  static setupForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.data}");
      print("Foreground message received: ${message.data}");
      print("Foreground message received: ${message.data}");
      print("Foreground message received: ${message.messageId}");
      print("Foreground message received: ${message.messageId}");
      print("Foreground message received: ${message.messageId}");
      print("Foreground message received: ${message.messageId}");
      print("Foreground message received: ${message.messageId}");
      print("Foreground message received: ${message.messageId}");
      if (message.notification != null && message.notification?.title != null && message.notification?.body != null) {
        FCMConfig().sendNotification(
          body: message.notification!.body!,
          title: message.notification!.title!,
        );
      } else {
        print("Foreground message received without notification payload.");
      }
    });
  }
}
