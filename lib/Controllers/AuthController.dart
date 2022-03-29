import 'package:dio/dio.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/employee/home.dart';
import 'package:elm_fyp/Views/organization/organization_nav.dart';
import 'package:flutter/material.dart';

class AuthController {
  login(BuildContext context, String email, String password) async {
    String url = Constants.baseURL + "/auth/login";
    try {
      try {
        Map<String, dynamic> payload = {"email": email, "password": password};
        var response = await Dio().post(url, data: payload);
        if (response.statusCode == 200) {
          var json = response.data['data'];
          Constants.USER_TOKEN = json['token'];
          Constants.setAuthentication();
          LocalStorage.setCredentials(email, password, json['_id']);
          if (json['role'] == "organization") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OrganizationNav(0)),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => EmployeeHome()),
                (route) => false);
          }
        }
      } catch (ex) {
        print(ex.toString());
      }
    } catch (ex) {
      print(ex);
    }
  }
}
