import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Constants {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Color primaryColor = const Color(0XFF0583d3);
  static String baseURL = "http://localhost:3000/api";
  static String mapURL = "http://a.tile.openstreetmap.org/{z}/{x}/{y}.png";
  static String USER_TOKEN = "";

  static setMapIP(String ip) {
    if (ip.contains(RegExp('[a-zA-Z]'))) {
      mapURL = "http://$ip/{z}/{x}/{y}.png";
    } else {
      mapURL = "http://$ip/tile/{z}/{x}/{y}.png";
      print("object");
    }
  }

  static Map<String, String> requestHeaders = {};
  static setAuthentication() {
    requestHeaders = {"Authorization": "Bearer " + USER_TOKEN};
  }

  static showSnackBar(BuildContext context, String msg, bool success) {
    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: msg,
        message: "asfddfa adfgsfgdfgdfgdf",
        messageSize: 0,
        backgroundColor: success ? const Color(0xFF303030) : Colors.red,
        duration: Duration(seconds: 2),
        animationDuration: const Duration(seconds: 1),
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn)
      ..show(context);
  }
}
