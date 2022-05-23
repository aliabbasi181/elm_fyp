import 'package:dio/dio.dart';
import 'package:elm_fyp/Controllers/EmployeeController.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/EmpoloyeeLocationModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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
      return responce.data['data'][0];
    } catch (ex) {}
  }

  Future<dynamic> getEmployeeLocationsOnDateAndTimeRange(String dateFrom,
      String dateTo, String timeFrom, String timeTo, String id) async {
    String url = Constants.baseURL +
        "/employee/get-employee-location-on-date-and-time-range";
    try {
      Map<String, dynamic> payload = {
        "employee": id,
        "from_date": dateFrom,
        "to_date": dateTo,
        "time_from": timeFrom,
        "time_to": timeTo
      };
      var responce = await Dio().post(url, data: payload);
      print(responce.data);
      return responce.data['data'];
    } catch (ex) {}
  }

  Future<dynamic> getEmployeeLocationsOnTimeRange(
      String date, String timeFrom, String timeTo, String id) async {
    String url =
        Constants.baseURL + "/employee/get-employee-location-on-time-range";
    try {
      Map<String, dynamic> payload = {
        "employee": id,
        "date": date,
        "time_from": timeFrom,
        "time_to": timeTo
      };
      var responce = await Dio().post(url, data: payload);
      print(responce.data);
      return responce.data['data'];
    } catch (ex) {}
  }

  Future<dynamic> getEmployeeLocationsOnDateRange(
      String dateFrom, String dateTo, String id) async {
    String url =
        Constants.baseURL + "/employee/get-employee-location-on-two-dates";
    try {
      Map<String, dynamic> payload = {
        "employee": id,
        "from_date": dateFrom,
        "to_date": dateTo,
      };
      var responce = await Dio().post(url, data: payload);
      return responce.data['data'];
    } catch (ex) {}
  }

  getEmployeesLastLocation(String date) async {
    String url = Constants.baseURL + "/employee/get-employees-last-location";
    try {
      Map<String, dynamic> payload = {"date": date};
      var responce = await Dio().post(url,
          options: Options(headers: Constants.requestHeaders), data: payload);
      for (var item in responce.data['data']) {
        if (item['inFence'].toString() == "false") {
          EmployeeController employeeController = EmployeeController();
          var res =
              await employeeController.employeeDetailById(item['employeeId']);
          //print(res['name'] + " is out of fence");
        }
      }
      return responce.data['data'];
    } catch (ex) {}
  }

  Future<dynamic> getEmployeesLocationOnFenceId(String id, String date) async {
    String url =
        Constants.baseURL + "/employee/get-employees-locations-on-fence-id";
    try {
      Map<String, dynamic> payload = {"id": id, "date": date};
      print(payload);
      var responce = await Dio().post(url, data: payload);
      return responce.data['data'];
    } catch (ex) {}
  }

  Future<dynamic> getEmployeesAllLocations(String id) async {
    String url = Constants.baseURL + "/employee/get-employee-all-locations";
    try {
      Map<String, dynamic> payload = {"id": id};
      var responce = await Dio().post(url, data: payload);
      return responce.data['data'];
    } catch (ex) {}
  }
}
