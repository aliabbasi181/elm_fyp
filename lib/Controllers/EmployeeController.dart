import 'package:dio/dio.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Views/constants.dart';

class EmployeeController {
  Future<bool> addEmployee(EmployeeModel employeeModel) async {
    String url = Constants.baseURL + "/employee/register/";
    Map<String, dynamic> payload = {
      "name": employeeModel.name,
      "email": employeeModel.email,
      "phone": employeeModel.phone,
      "password": employeeModel.password,
      "cnic": employeeModel.cnic,
      "designation": employeeModel.designation
    };
    try {
      var response = await Dio().post(url,
          data: payload, options: Options(headers: Constants.requestHeaders));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
    return false;
  }

  Future<List<dynamic>> getEmployees() async {
    String url = Constants.baseURL + "/employee/";
    List<dynamic> employees = [];
    try {
      var response = await Dio()
          .get(url, options: Options(headers: Constants.requestHeaders));
      if (response.statusCode == 200) {
        employees = response.data['data'];
      }
    } catch (ex) {
      print(ex.toString());
    }
    return employees;
  }

  Future<bool> deleteEmployee(String id) async {
    String url = Constants.baseURL + "/auth/delete";
    try {
      var response = await Dio().delete(url, data: {"id": id});
      if (response.statusCode == 200) {
        return true;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
    return false;
  }

  employeeDetail() async {
    String url = Constants.baseURL + "/employee/employeeDetail";
    try {
      var response = await Dio()
          .get(url, options: Options(headers: Constants.requestHeaders));
      if (response.statusCode == 200) {
        Constants.employee = EmployeeModel.fromJson(response.data['data']);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  employeeDetailById(String id) async {
    String url = Constants.baseURL + "/employee/get-employee-by-id";
    try {
      Map<String, dynamic> payload = {"id": id};
      var response = await Dio().post(url, data: payload);
      if (response.statusCode == 200) {
        return response.data['data'];
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<EmployeeModel> employeeUpdateStatus(String id, bool status) async {
    String url = Constants.baseURL + "/employee/change-active-status";
    EmployeeModel organization = EmployeeModel();
    Map<String, dynamic> payload = {
      "id": id,
      "active": status,
      "msg": "Some message"
    };
    try {
      var response = await Dio().post(url, data: payload);
      if (response.statusCode == 200) {
        var json = response.data['data'];
        organization = EmployeeModel.fromJson(json);
      }
    } catch (ex) {}
    return organization;
  }
}
