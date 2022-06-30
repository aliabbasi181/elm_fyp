import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

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
  static EmployeeModel employee = EmployeeModel();
  static String rganizationName = "";
  static OrganizationModel organization = OrganizationModel();
// http://a.tile.openstreetmap.org/{z}/{x}/{y}.png
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

class DistanceService {
  static double findDistance(LatLng from, LatLng to) {
    var lat1 = toRadian(from.latitude);
    var lng1 = toRadian(from.longitude);
    var lat2 = toRadian(to.latitude);
    var lng2 = toRadian(to.longitude);

    // Haversine Formula
    var dlong = lng2 - lng1;
    var dlat = lat2 - lat1;

    var res = pow(sin((dlat / 2)), 2) +
        cos(lat1) * cos(lat2) * pow(sin(dlong / 2), 2);
    res = 2 * asin(sqrt(res));
    double R = 6371;
    res = res * R;
    return res;
  }

  static double toRadian(double val) {
    double one_deg = (pi) / 180;
    return (one_deg * val);
  }
}
