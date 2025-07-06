import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMConfig {
  int _notificationCounter = 0;

  Future<void> initAwesomeNotification() async {
    print("🚀 Initializing Awesome Notifications...");
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: false,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic Group',
        ),
      ],
      debug: true,
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );

    print("✅ Awesome Notifications initialized.");
  }

  Future<void> requestPermission() async {
    print("🔐 Requesting Firebase Messaging permission...");
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('📡 Firebase Messaging Permission Status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Firebase Messaging permission granted.');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('❌ Firebase Messaging permission denied.');
    } else {
      print('ℹ️ Firebase Messaging permission is provisional or not requested yet.');
    }

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    print('🔔 Is Awesome Notifications permission allowed? $isAllowed');

    if (!isAllowed) {
      print('📥 Requesting Awesome Notifications permission...');
      bool granted = await AwesomeNotifications().requestPermissionToSendNotifications();

      if (granted) {
        print('✅ Awesome Notifications permission granted by user.');
      } else {
        print('❌ Awesome Notifications permission DENIED by user.');
      }
    } else {
      print('✅ Awesome Notifications permission already granted.');
    }
  }

  Future<void> sendNotification({required String title, required String body}) async {
    _notificationCounter++;

    print("📤 Preparing to send notification #$_notificationCounter...");
    print("🧾 Notification content => Title: $title | Body: $body");

    bool success = await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _notificationCounter,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        wakeUpScreen: true,
        backgroundColor: Colors.blueAccent,
      ),
    );

    if (success) {
      print("✅ Notification ($_notificationCounter) created successfully.");
    } else {
      print("❌ Failed to create notification ($_notificationCounter).");
    }
  }
}

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    print('🆕 Notification created: ID=${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    print('📺 Notification displayed: ID=${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    print('🗑️ Notification dismissed: ID=${receivedAction.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    print('👆 Notification action received: ID=${receivedAction.id}');
    print('🔘 Button Key Pressed: ${receivedAction.buttonKeyPressed}');
    print('📦 Payload: ${receivedAction.payload}');
  }
}
