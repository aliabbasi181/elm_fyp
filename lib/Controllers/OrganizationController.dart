import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:dio/dio.dart';
import 'package:elm_fyp/Views/constants.dart';

class OrganizationController {
  Future<bool> addOrganization(
      OrganizationModel organizationModel, String user) async {
    String url = Constants.baseURL + "/auth/register";
    Map<String, dynamic> payload;
    if (user == "admin") {
      payload = {
        "name": organizationModel.name,
        "email": organizationModel.email,
        "address": organizationModel.address,
        "password": organizationModel.password,
        "isConfirmed": true
      };
    } else {
      payload = {
        "name": organizationModel.name,
        "email": organizationModel.email,
        "address": organizationModel.address,
        "password": organizationModel.password,
        "isConfirmed": false
      };
    }

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

  Future<OrganizationModel> organizationUpdateStatus(
      String id, bool status) async {
    String url = Constants.baseURL + "/auth/change-org-status";
    OrganizationModel organization = OrganizationModel();
    Map<String, dynamic> payload = {
      "id": id,
      "active": status,
    };
    try {
      var response = await Dio().post(url, data: payload);
      if (response.statusCode == 200) {
        var json = response.data['data'];
        organization = OrganizationModel.fromJson(json);
      }
    } catch (ex) {}
    return organization;
  }
}
