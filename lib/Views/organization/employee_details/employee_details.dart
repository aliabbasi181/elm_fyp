import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/AssignedFenceModel.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/EmpoloyeeLocationModel.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/employee/employee_history.dart';
import 'package:elm_fyp/Views/employee/employee_locations_log.dart';
import 'package:elm_fyp/Views/employee/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class EmployeeDetails extends StatefulWidget {
  EmployeeModel employee;
  EmployeeDetails({Key? key, required this.employee}) : super(key: key);

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  MapController mapController = MapController();
  List<LatLng> latlnglist = <LatLng>[];
  LatLng center = LatLng(33.6635, 73.0841);
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  String dateinstringFrom = "From";
  String dateinstringTo = "To";
  String fromTime = "From:- 09:30 AM";
  String toTime = "To:- 06:30 PM";
  String pickFence = "Select Location";
  List<LatLng> fenceList = <LatLng>[];
  List<AssignedFenceModel> assignedFences = [];
  FenceModel todaysFence = FenceModel(name: "Loading...");
  double _zoomValue = 14;
  EmployeeLocationModel employeeLocationModel = EmployeeLocationModel();

  _getTodayLocations() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    var today = DateTime.now();
    var data = await applicationBloc.getEmployeeLocationsOnDate(
        "${today.day}/${today.month}/${today.year}",
        widget.employee.sId.toString());
    if (data != null) {
      latlnglist.clear();
      for (var item in data['locations']) {
        latlnglist.add(LatLng(item['lat'], item['lng']));
      }
      employeeLocationModel = EmployeeLocationModel.fromJson(data);
      data = await applicationBloc
          .getFenceById(employeeLocationModel.fence.toString());
      if (data != null) {
        List<Points> points = [];
        for (var item in data['points']) {
          points.add(Points(lat: item['lat'], lng: item['lng']));
        }
        todaysFence = FenceModel(name: data['name'], points: points);
        print(todaysFence.name);
      }
      double lat = 0, lng = 0;
      if (todaysFence.points != null) {
        fenceList = [];
        for (var item in todaysFence.points!) {
          lat += double.parse(item.lat.toString());
          lng += double.parse(item.lng.toString());
          fenceList.add(LatLng(double.parse(item.lat.toString()),
              double.parse(item.lng.toString())));
        }
        lat = lat / todaysFence.points!.length;
        lng = lng / todaysFence.points!.length;
        center = LatLng(lat, lng);
      }
      mapController.move(LatLng(lat, lng), _zoomValue);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("Alert!"),
                content: Text("No locations found"),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ));
    }
    setState(() {});
  }

  @override
  void initState() {
    _getTodayLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
        body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
      Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          height: Constants.screenHeight(context),
          width: Constants.screenWidth(context),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background_image.jpg"),
                  fit: BoxFit.fill)),
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Text(
                        widget.employee.name.toString(),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          widget.employee.designation.toString(),
                          style: FontStyle(14, Colors.white, FontWeight.w500),
                        ),
                      )
                    ],
                  ))
                ],
              ),
              SizedBox(
                height: Constants.screenWidth(context) * 0.015,
              ),
              Text(
                "Assigned Fence: ${todaysFence.name}",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: Constants.screenWidth(context) * 0.015,
              ),
              Container(
                height: Constants.screenHeight(context) * 0.6,
                width: Constants.screenWidth(context),
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 35,
                        blurStyle: BlurStyle.outer)
                  ],
                  color: Constants.primaryColor,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: Constants.screenHeight(context) * 0.6,
                        width: Constants.screenWidth(context),
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            center: center,
                            zoom: _zoomValue,
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate: Constants.mapURL,
                            ),
                            PolylineLayerOptions(polylines: [
                              Polyline(
                                  color: Colors.black,
                                  strokeWidth: 8,
                                  isDotted: true,
                                  points: latlnglist)
                            ]),
                            PolylineLayerOptions(polylines: [
                              Polyline(
                                  color: Constants.primaryColor,
                                  strokeWidth: 5,
                                  points: fenceList)
                            ]),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  point: latlnglist.isNotEmpty
                                      ? latlnglist.last
                                      : LatLng(0, 0),
                                  builder: (ctx) => Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 10),
                                    ]),
                                    child: const Icon(
                                      Icons.circle_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 60,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        margin: const EdgeInsets.only(bottom: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                print(_zoomValue);
                                var temp = _zoomValue;
                                if (temp++ < 14 || temp++ == 14) {
                                  setState(() {
                                    _zoomValue++;
                                    mapController.move(center, _zoomValue);
                                  });
                                }
                              },
                              child: Icon(
                                CupertinoIcons.plus,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var temp = _zoomValue;
                                if (temp-- > 5 || temp-- == 5) {
                                  setState(() {
                                    _zoomValue--;
                                    mapController.move(center, _zoomValue);
                                  });
                                }
                              },
                              child: Icon(
                                CupertinoIcons.minus,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      List<FenceModel> fences = [];
                      for (var item in assignedFences) {
                        var data = await applicationBloc
                            .getFenceById(item.region.toString());
                        print(data);
                        if (data != null) {
                          fences.add(FenceModel.fromJson(data));
                        }
                      }
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return SafeArea(
                              bottom: false,
                              child: Container(
                                width: Constants.screenWidth(context),
                                height: Constants.screenHeight(context),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: ShowAssignedFences(
                                  fences: fences,
                                  assignedFences: assignedFences,
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Other assigned fences",
                        style: FontStyle(14, Colors.white, FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _getTodayLocations();
                      if (todaysFence.points == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: Text("Alert!"),
                                  content: Text("No locations found"),
                                  actions: [
                                    CupertinoDialogAction(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeLocationsLog(
                                    name: widget.employee.name.toString(),
                                    assignedFence: todaysFence.name.toString(),
                                    employeeLocationModel:
                                        employeeLocationModel)));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "View Log",
                        style: FontStyle(14, Colors.white, FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ))),
      NavBox(
          buttonText: "View History",
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmployeeHistory(
                          employeeId: widget.employee.sId.toString(),
                        )));
          })
    ]));
  }
}
