import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:elm_fyp/Controllers/EmployeeController.dart';
import 'package:elm_fyp/Controllers/EmployeeLocationController.dart';
import 'package:elm_fyp/Controllers/OrganizationController.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/employee/employee_nav.dart';
import 'package:elm_fyp/Views/employee/home.dart';
import 'package:elm_fyp/Views/organization/organization_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

class AuthController {
  login(BuildContext context, String email, String password) async {
    String url = Constants.baseURL + "/auth/login";
    try {
      try {
        // cron
        var cron = new Cron();

        Map<String, dynamic> payload = {"email": email, "password": password};
        var response = await Dio().post(url, data: payload);
        if (response.statusCode == 200) {
          var json = response.data['data'];
          Constants.USER_TOKEN = json['token'];
          Constants.setAuthentication();
          LocalStorage.setCredentials(email, password, json['_id']);
          getUserData();
          if (json['role'] == "organization") {
            if (json['isConfirmed'].toString() == "false") {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text("You are forbidden to log in"),
                        content: Text("Note: " +
                            json['unactive_msg'].toString() +
                            "\nFor further queries contact with ELMS admin."),
                        actions: [
                          CupertinoDialogAction(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      ));
              return;
            }
            EmployeeLocationController employeeLocationController =
                EmployeeLocationController();
            // cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
            //   print(
            //       "_______________________________________\nOrganization\n_______________________________________");
            //   employeeLocationController.getEmployeesLastLocation();
            // });
            OrganizationController organizationController =
                OrganizationController();
            Constants.organization = OrganizationModel.fromJson(json);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OrganizationNav(1)),
                (route) => false);
          } else {
            // cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
            //   print(
            //       "_______________________________________\nEmployee\n_______________________________________");
            // });
            print(json);
            if (json['status'].toString() == "false") {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text("You are forbidden to log in"),
                        content: Text("Note: " +
                            json['unactive_msg'].toString() +
                            "\nFor further queries contact with your organization."),
                        actions: [
                          CupertinoDialogAction(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      ));
            } else {
              EmployeeController employeeController = EmployeeController();
              await employeeController.employeeDetail();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeNav(1)),
                  (route) => false);
            }
          }
        } else {
          Constants.showSnackBar(
              context, "Invalid username or password", false);
        }
      } catch (ex) {
        print(ex.toString());
        Constants.showSnackBar(context, "Invalid username or password", false);
      }
    } catch (ex) {
      print(ex);
      Constants.showSnackBar(context, "Invalid username or password", false);
    }
  }

  getUserData() async {
    String url = Constants.baseURL + "/auth/get-user-data";
    try {
      var response = await Dio()
          .get(url, options: Options(headers: Constants.requestHeaders));
      if (response.statusCode == 200) {
        if (response.data['role'] == "organization") {
          Constants.organization = OrganizationModel.fromJson(response.data);
        } else {
          Constants.employee = EmployeeModel.fromJson(response.data);
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
