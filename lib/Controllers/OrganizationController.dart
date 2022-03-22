import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:dio/dio.dart';
import 'package:elm_fyp/Views/constants.dart';

class OrganizationController {
  Future<bool> addOrganization(OrganizationModel organizationModel) async {
    String url = Constants.baseURL + "/auth/register";
    Map<String, dynamic> payload = {
      "name": organizationModel.name,
      "email": organizationModel.email,
      "address": organizationModel.address,
      "password": organizationModel.password
    };
    try {
      var response = await Dio().post(url, data: payload);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
    return false;
  }

  Future<List<dynamic>> getOrganizations() async {
    String url = Constants.baseURL + "/auth/organizations";
    List<dynamic> organizations = [];
    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        organizations = response.data['data'];
      }
    } catch (ex) {
      print(ex.toString());
    }
    return organizations;
  }

  Future<bool> deleteOrganization(String id) async {
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
