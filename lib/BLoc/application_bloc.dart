import 'package:elm_fyp/Controllers/AuthController.dart';
import 'package:elm_fyp/Controllers/EmployeeController.dart';
import 'package:elm_fyp/Controllers/EmployeeLocationController.dart';
import 'package:elm_fyp/Controllers/FenceController.dart';
import 'package:elm_fyp/Controllers/OrganizationController.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ApplicationBloc with ChangeNotifier {
  final OrganizationController organizationController =
      OrganizationController();
  final AuthController authController = AuthController();
  final EmployeeController employeeController = EmployeeController();
  final FenceController fenceController = FenceController();
  final EmployeeLocationController employeeLocationController =
      EmployeeLocationController();

  ApplicationBloc() {
    print("Bloc Working");
  }

  bool loading = false;

  Future<bool> addOrganization(
      OrganizationModel organizationModel, String user) async {
    loading = true;
    notifyListeners();
    if (await organizationController.addOrganization(organizationModel, user)) {
      loading = false;
      notifyListeners();
      return true;
    }
    loading = false;
    notifyListeners();
    return false;
  }

  Future<List<dynamic>> getOrganizations() async {
    loading = true;
    notifyListeners();
    List<dynamic> organizations =
        await organizationController.getOrganizations();
    loading = false;
    notifyListeners();
    return organizations;
  }

  Future<bool> deleteOrganization(String id) async {
    bool res;
    loading = true;
    notifyListeners();
    res = await organizationController.deleteOrganization(id);
    loading = false;
    notifyListeners();
    return res;
  }

  login(BuildContext context, String email, String password) async {
    loading = true;
    notifyListeners();
    await authController.login(context, email, password);
    loading = false;
    notifyListeners();
  }

  Future<bool> addEmployee(EmployeeModel employeeModel) async {
    loading = true;
    notifyListeners();
    if (await employeeController.addEmployee(employeeModel)) {
      loading = false;
      notifyListeners();
      return true;
    }
    loading = false;
    notifyListeners();
    return false;
  }

  Future<List<dynamic>> getEmployees() async {
    loading = true;
    notifyListeners();
    List<dynamic> organizations = await employeeController.getEmployees();
    loading = false;
    notifyListeners();
    return organizations;
  }

  Future<List<dynamic>> getFences() async {
    return await fenceController.getFences();
  }

  Future<bool> createFence(String name, List<LatLng> points) async {
    loading = true;
    notifyListeners();
    if (await fenceController.createFence(name, points)) {
      loading = false;
      notifyListeners();
      return true;
    }
    loading = false;
    notifyListeners();
    return false;
  }

  assignFenceToOneEmployee(BuildContext context, String empId, String regId,
      String dateFrom, String dateTo, String timeFrom, String timeTo) async {
    loading = true;
    notifyListeners();
    await fenceController.assignFenceToOneEmployee(
        context, empId, regId, dateFrom, dateTo, timeFrom, timeTo);
    loading = false;
    notifyListeners();
  }

  Future<List<dynamic>> getAssignedFences() async {
    return await fenceController.getAssignedFences();
  }

  Future<dynamic> getFenceById(String id) async {
    return await fenceController.getFenceById(id);
  }

  saveUserLocation(
      LatLng latLng, String date, String time, BuildContext context) async {
    await employeeLocationController.saveUserLocation(
        latLng, date, time, context);
  }

  Future<dynamic> getEmployeeLocationsOnDate(String date, String id) async {
    return await employeeLocationController.getEmployeeLocationsOnDate(
        date, id);
  }

  employeeDetail() async {
    await employeeController.employeeDetail();
  }

  Future<OrganizationModel> organizationUpdateStatus(
      String id, bool status) async {
    return await organizationController.organizationUpdateStatus(id, status);
  }

  Future<EmployeeModel> employeeUpdateStatus(String id, bool status) async {
    return await employeeController.employeeUpdateStatus(id, status);
  }
}
