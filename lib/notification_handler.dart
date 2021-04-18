import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_lovers/common_widgets/platform_duyarli_alert_dialog.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arka Planda Gelen Data:" + message['data'].toString());
    NotificationHandler.showNotification(message);
  }

  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();
  static final NotificationHandler _singleton = NotificationHandler._internal();
  factory NotificationHandler() {
    return _singleton;
  }
  NotificationHandler._internal();

  initializeFCMNotification(BuildContext context) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.subscribeToTopic("spor");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage TETİKLENDİ: $message");
        showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch TETİKLENDİ: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume TETİKLENDİ: $message");
      },
    );
  }

  static void showNotification(Map<String, dynamic> message) async {
    print("??????????????????????????????? showa gelen message:" +
        message.toString());

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '12345', 'Yeni mesaj', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['data']['title'],
        message['data']['message'], platformChannelSpecifics,
        payload: 'Bildirim tıklanılınca aktarılan değer');
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  Future onSelectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }
}
