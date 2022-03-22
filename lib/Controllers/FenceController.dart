import 'package:dio/dio.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:latlong2/latlong.dart';

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
}
