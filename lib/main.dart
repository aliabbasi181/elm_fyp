import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Views/admin/admin_nav.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:elm_fyp/Views/organization/organization_nav.dart';
import 'package:elm_fyp/Views/splash.dart';
import 'package:elm_fyp/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelKey: "basic_channel",
          channelName: "Basic Channel",
          channelDescription: "Channel for send alert to users",
          importance: NotificationImportance.High,
          defaultColor: const Color.fromARGB(255, 0, 0, 0),
          channelShowBadge: true)
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    ELMNotification.listenELMNotification();
  } catch (ex) {
    print(ex);
  }
  runApp(
    ChangeNotifierProvider(
      create: ((context) => ApplicationBloc()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    ),
  );
}
