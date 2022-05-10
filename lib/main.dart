import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron/cron.dart';
import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/admin/admin_nav.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:elm_fyp/Views/organization/organization_nav.dart';
import 'package:elm_fyp/Views/splash.dart';
import 'package:elm_fyp/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
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
  // cron
  // var cron = new Cron();
  // cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
  //   print(await _determinePosition());
  // });
  // shared preferences
  await LocalStorage.init();
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

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
