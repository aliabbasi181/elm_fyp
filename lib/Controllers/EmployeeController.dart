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
}
