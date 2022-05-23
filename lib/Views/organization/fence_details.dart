import 'dart:async';

import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/organization/employee_details/employee_details.dart';
import 'package:elm_fyp/Views/organization/update_fence.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:elm_fyp/local_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class FenceDetail extends StatefulWidget {
  FenceModel fence;
  FenceDetail({Key? key, required this.fence}) : super(key: key);

  @override
  _FenceDetailState createState() => _FenceDetailState();
}

class _FenceDetailState extends State<FenceDetail> {
  List<LatLng> latlnglist = <LatLng>[];
  List<LatLng> userPoints = <LatLng>[];
  MapController mapController = MapController();
  List<Marker> marker = [];
  LatLng? center;
  double _zoomValue = 14;
  List<Polyline> allLines = [];
  List<Marker> allMarkers = [];
  Timer? timer;
  List<Map<String, dynamic>> employees = [];
  @override
  initState() {
    super.initState();
    double lat = 0, lng = 0;
    for (var item in widget.fence.points!) {
      lat += double.parse(item.lat.toString());
      lng += double.parse(item.lng.toString());
      latlnglist.add(LatLng(double.parse(item.lat.toString()),
          double.parse(item.lng.toString())));
    }
    lat = lat / widget.fence.points!.length;
    lng = lng / widget.fence.points!.length;
    center = LatLng(lat, lng);
    allLines.add(Polyline(
        points: latlnglist, strokeWidth: 5, color: Constants.primaryColor));
    getLocations();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      getLocations();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getLocations() async {
    allMarkers = [];
    employees = [];
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    var today = DateTime.now();
    var data = await applicationBloc
        .getEmployeesLastLocation("${today.day}/${today.month}/${today.year}");
    //print(data);
    for (var item in data) {
      if (item['fenceId'].toString() == widget.fence.sId.toString()) {
        var emp =
            await applicationBloc.getEmployeeDetailById(item['employeeId']);
        employees.add({
          "employee": EmployeeModel.fromJson(emp),
          "in_fence": item['inFence']
        });
        if (item['inFence'].toString() == "false") {
          ELMNotification.notify(
              "Warning!", "${emp['name']} is out of fence", "basic_channel");
        }
        allMarkers.add(Marker(
            width: 150,
            height: 50,
            point: LatLng(double.parse(item['lat'].toString()),
                double.parse(item['lng'].toString())),
            builder: (context) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeDetails(
                              employee: EmployeeModel.fromJson(emp))));
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: Constants.primaryColor,
                      child: Text(
                        emp['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(color: Colors.black54, blurRadius: 10),
                      ]),
                      child: Icon(
                        Icons.circle,
                        color: item['inFence'] ? Colors.black : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }));
      }
    }
    setState(() {});
    // var data = await applicationBloc.getEmployeesLocationOnFenceId(
    //     widget.fence.sId.toString(),
    //     "${today.day}/${today.month}/${today.year}");
    // List<LatLng> points = [];
    // for (var item in data) {
    //   points = [];
    //   print(item['']);
    //   allLines.add(Polyline(
    //       points: points, strokeWidth: 5, isDotted: true, color: Colors.black));
    // }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
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
                        child: Text(
                          widget.fence.name.toString(),
                          style: FontStyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateFence(fence: widget.fence)));
                            },
                            icon: const Icon(Icons.edit_location_alt_rounded),
                            label: Text("Edit",
                                style: FontStyle(
                                    16, Colors.white, FontWeight.w500)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {},
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Constants.primaryColor)),
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: Text("Delete",
                                style: FontStyle(
                                    16, Colors.white, FontWeight.w500)),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: Constants.screenWidth(context) * 0.010,
                  ),
                  Container(
                    height: Constants.screenHeight(context) * 0.5,
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
                            height: Constants.screenHeight(context) * 0.5,
                            width: Constants.screenWidth(context),
                            child: FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                center: center,
                                zoom: _zoomValue,
                                onTap: (position, latlng) {
                                  print(
                                      "${latlng.latitude},${latlng.longitude}");
                                  setState(() {
                                    // marker.add(Marker(
                                    //     point: latlng,
                                    //     builder: (context) {
                                    //       return const Icon(Icons.location_on);
                                    //     }));
                                  });
                                },
                              ),
                              layers: [
                                TileLayerOptions(urlTemplate: Constants.mapURL),
                                PolylineLayerOptions(polylines: [
                                  Polyline(
                                      points: latlnglist,
                                      strokeWidth: 5,
                                      color: Constants.primaryColor)
                                ]),
                                MarkerLayerOptions(markers: allMarkers),
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
                            margin:
                                const EdgeInsets.only(bottom: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    var temp = _zoomValue;
                                    if (temp++ < 14 || temp++ == 14) {
                                      setState(() {
                                        _zoomValue++;
                                        mapController.move(center!, _zoomValue);
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
                                        mapController.move(center!, _zoomValue);
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
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
                                      child:
                                          ViewEmployeesOverview(fenceId: "")),
                                );
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "View assigned employees",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                          width: Constants.screenWidth(context),
                          child: ListView.builder(
                            itemCount: employees.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EmployeeDetails(
                                              employee: employees[index]
                                                  ['employee'])));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10, top: 15, bottom: 15),
                                  margin: const EdgeInsets.only(
                                      top: 12, left: 0, right: 2),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black, blurRadius: 1.5)
                                    ],
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(stops: const [
                                      0.015,
                                      0.01
                                    ], colors: [
                                      Constants.primaryColor,
                                      const Color.fromRGBO(255, 255, 255, 1)
                                    ]),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              employees[index]['employee'].name,
                                              style: FontStyle(
                                                  20,
                                                  Constants.primaryColor,
                                                  FontWeight.w500))),
                                      Text(
                                          employees[index]['in_fence']
                                              ? "In fence"
                                              : "Out of fence",
                                          style: FontStyle(
                                              14,
                                              employees[index]['in_fence']
                                                  ? Colors.green
                                                  : Colors.red,
                                              FontWeight.w500))
                                    ],
                                  ),
                                ),
                              );
                            },
                          )))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewEmployeesOverview extends StatefulWidget {
  String fenceId;
  ViewEmployeesOverview({Key? key, required this.fenceId}) : super(key: key);

  @override
  State<ViewEmployeesOverview> createState() => _ViewEmployeesOverviewState();
}

class _ViewEmployeesOverviewState extends State<ViewEmployeesOverview> {
  //List<EmployeeLocationModel> locations = [];
  List<Map<String, dynamic>> locations = [];
  @override
  void initState() {
    _getEmployees();
    super.initState();
  }

  _getEmployees() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    locations.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Employees overview',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Container(
              height: Constants.screenHeight(context) * 0.45,
              child: ListView.builder(
                  itemCount: 3,
                  padding: const EdgeInsets.only(top: 10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, locations[index]);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: Constants.screenWidth(context),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name",
                                style: FontStyle(18, Constants.primaryColor,
                                    FontWeight.w500)),
                            RichText(
                                text: TextSpan(
                                    text: "Date: ",
                                    style: FontStyle(
                                        12, Colors.black, FontWeight.w500),
                                    children: [
                                  TextSpan(
                                      text: "  12/5/2022",
                                      style: FontStyle(
                                          12,
                                          Colors.black.withOpacity(0.5),
                                          FontWeight.w400)),
                                ])),
                            const Divider(
                              color: Color(0XFFFeceef0),
                              thickness: 1,
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
