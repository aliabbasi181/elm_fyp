import 'package:dio/dio.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/EmpoloyeeLocationModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class EmployeeLocationController {
  Future<dynamic> saveUserLocation(
      LatLng latLng, String date, String time, BuildContext context) async {
    String url = Constants.baseURL + "/employee/addLocation";
    dynamic data;
    List<UserLocationModel> locations = [];
    try {
      Map<String, dynamic> payload = {
        "date": date,
        "time": time,
        "lat": latLng.latitude,
        "lng": latLng.longitude
      };
      var responce = await Dio().post(url,
          data: payload, options: Options(headers: Constants.requestHeaders));
      if (responce.data['message'] != "location added Success.") {
        Constants.showSnackBar(context, responce.data['message'], false);
        return;
      }
      if (responce.statusCode == 200) {
        for (var item in responce.data['data']['locations']) {
          locations.add(UserLocationModel(
              lat: item['lat'].toString(),
              lng: item['lng'].toString(),
              time: item['time'].toString(),
              inFence: item['inFence']));
        }
        if (locations.length > 0) {
          if (locations.last.inFence.toString() == "true") {
            print("In the fence");
          } else {
            print("Out of fence");
            ELMNotification.notify(
                "Warning!", "You are out of fence", "basic_channel");
          }
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<dynamic> getEmployeeLocationsOnDate(String date, String id) async {
    String url = Constants.baseURL + "/employee/get-employee-location-on-date";
    try {
      Map<String, dynamic> payload = {"date": date, "employee": id};
      var responce = await Dio().post(url, data: payload);
      print(responce.data);
      return responce.data['data'][0];
    } catch (ex) {}
  }
}
