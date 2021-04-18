import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_lovers/common_widgets/platform_duyarli_alert_dialog.dart';

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arka Planda Gelen Data:" + message['data'].toString());
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
    _fcm.subscribeToTopic("spor");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage TETİKLENDİ: $message");

        PlatformDuyarliAlertDialog(
          baslik: "test1",
          icerik: "test2",
          anaButtonYazisi: "OK",
        ).goster(context);
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
}
