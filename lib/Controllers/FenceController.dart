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
      Map<String, dynamic> payload = {"name": name, "points": points};
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
        var json = jsonDecode(response.body);
        print(json);
        Constants.showSnackBar(context, json['message'].toString(), true);
      } else {
        var json = jsonDecode(response.body);
        Constants.showSnackBar(context, json['message'].toString(), true);
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<List<dynamic>> getAssignedFences() async {
    List<dynamic> assignedFences = [];
    try {
      String url = Constants.baseURL + "/geo/polygon/get-assigned-fences";
      var response = await Dio()
          .get(url, options: Options(headers: Constants.requestHeaders));
      assignedFences = response.data['data'];
      return assignedFences;
    } catch (ex) {
      print(ex);
      return assignedFences;
    }
  }

  Future<dynamic> getFenceById(String id) async {
    dynamic fence;
    try {
      String url = Constants.baseURL + "/geo/polygon/polygonDetail";
      Map<String, dynamic> payload = {
        "id": id,
      };
      var response = await Dio().post(url, data: payload);
      fence = response.data['data'];
    } catch (ex) {
      print(ex);
    }
    return fence;
  }

  Future<dynamic> getEmployeesLastLocation() async {
    String url = Constants.baseURL + "/employee/get-employees-last-location";
    try {
      var responce = await Dio()
          .post(url, options: Options(headers: Constants.requestHeaders));
      print(responce.data);
      return responce.data['data'];
    } catch (ex) {}
  }

  Future<dynamic> getEmployeesAssignedFence(String id) async {
    String url =
        Constants.baseURL + "/geo/polygon/get-employees-assigned-fence";
    try {
      var responce = await Dio().post(url,
          options: Options(headers: Constants.requestHeaders),
          data: {"id": id});
      print(responce.data);
      return responce.data['data'];
    } catch (ex) {}
  }

  Future<dynamic> getFenceHistory(String id) async {
    String url = Constants.baseURL + "/employee/fence-history";
    try {
      var responce = await Dio().post(url, data: {"id": id});
      print(responce.data);
      return responce.data['data'];
    } catch (ex) {}
  }

  Future<bool> updateFence(String name, List<LatLng> points, var id) async {
    String url = Constants.baseURL + "/geo/polygon/update";
    List<Map<String, dynamic>> pointsJson = [];
    for (var item in points) {
      pointsJson.add({'lat': item.latitude, 'lng': item.longitude});
    }
    var payload = {'id': id, 'name': name, 'points': pointsJson};
    try {
      var responce = await Dio().post(url,
          data: payload, options: Options(headers: Constants.requestHeaders));
      print(responce.data);
      if (responce.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }
}
