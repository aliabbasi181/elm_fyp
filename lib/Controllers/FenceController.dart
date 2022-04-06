import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class FenceController {
  getFences() async {
    String url = Constants.baseURL + "/geo/polygon/";
    List<dynamic> fences = [];
    try {
      var response = await Dio()
          .get(url, options: Options(headers: Constants.requestHeaders));
      if (response.statusCode == 200) {
        fences = response.data['data'];
      }
    } catch (ex) {
      print(ex.toString());
    }
    return fences;
  }

  Future<bool> createFence(String name, List<LatLng> points) async {
    String url = Constants.baseURL + "/geo/polygon/";
    try {
      FenceModel polygon = FenceModel();
      List<Points> pointsP = [];
      polygon.name = name;
      String lat, lng;
      for (var i = 0; i < points.length; i++) {
        lat = points[i].latitude.toString();
        lng = points[i].longitude.toString();
        pointsP.add(Points(lat: lat, lng: lng));
      }
      polygon.points = pointsP;
      var body = polygon.toJson();
      var response = await Dio().post(url,
          options: Options(headers: Constants.requestHeaders), data: body);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
    return false;
  }

  assignFenceToOneEmployee(BuildContext context, String empId, String regId,
      String dateFrom, String dateTo, String timeFrom, String timeTo) async {
    String url = Constants.baseURL + "/geo/polygon/assign-fence";
    try {
      Map<String, dynamic> payload = {
        "employee_id": empId,
        "region_id": regId,
        "date_from": dateFrom,
        "date_to": dateTo,
        "start_time": timeFrom,
        "end_time": timeTo
      };
      var response = await http.post(Uri.parse(url),
          body: payload, headers: Constants.requestHeaders);
      if (response.statusCode == 200) {
        Constants.showSnackBar(
            context, "Fence successfully assigned to employee", true);
      } else {
        var json = jsonDecode(response.body);
        Constants.showSnackBar(context, json['message'].toString(), true);
      }
    } catch (ex) {
      print(ex);
    }
  }
}
