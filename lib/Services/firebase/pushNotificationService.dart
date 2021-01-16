import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/notification.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/promotion.dart';

class NotificationService {
  BuildContext context;

  NotificationService({this.context});

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future initializeService() async {
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        navigatorSerialiser(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        navigatorSerialiser(message);
      },
      onResume: (Map<String, dynamic> message) async {
        navigatorSerialiser(message);
      },
    );
  }

  navigatorSerialiser(Map<String, dynamic> message) {
    final notificationData = message['data'];
    final category = notificationData['category'];
    final title = notificationData['title'];
    final body = notificationData['body'];
    final imageUrl = notificationData['imageUrl'];

    if (category != null && category == 'orderNotification') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height,
          child: NotificationScreen(),
        ),
      );
    } else if (category != null && category == 'promotion') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            child: PromotionDetailView(
              title: title,
              body: body,
              imageUrl: imageUrl,
            )),
      );
    }
  }

  Future<String> getTokenString() async {
    String getTokenString = await _firebaseMessaging.getToken();

    return getTokenString;
  }
}
