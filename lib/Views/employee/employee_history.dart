import 'dart:convert';
import 'dart:math';

import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/EmpoloyeeLocationModel.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class EmployeeHistory extends StatefulWidget {
  String employeeId;
  EmployeeHistory({Key? key, required this.employeeId}) : super(key: key);

  @override
  _EmployeeHistoryState createState() => _EmployeeHistoryState();
}

class Fence {
  String name;
  Fence(this.name);
}

class _EmployeeHistoryState extends State<EmployeeHistory> {
  List<LatLng> latlnglist = <LatLng>[];
  List<Color> fence_colors = [];
  MapController mapController = MapController();
  List<Fence> fences = [];
  List<LatLng> fenceList = [LatLng(33.5651, 73.0169)];
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  String dateinstringFrom = "From";
  String dateinstringTo = "To";
  String fromTime = "From -:-";
  String toTime = "To -:-";
  FenceModel fence = FenceModel(name: "Select Fence");
  double _zoomValue = 14;
  LatLng center = LatLng(33.658664032, 73.085499658);
  List<Polygon> allFences = [];
  List<Polyline> allLines = [];
  List<String?> user = [];
  List<Marker> markers = [];
  String resultDate = '';
  String totalresults = '0';
  List<Map<String, dynamic>> locationsResult = [];
  String empName = '';
  LatLng markerPoint = LatLng(0, 0);
  Color markerPointColor = Colors.black;
  @override
  initState() {
    print(widget.employeeId);
    super.initState();
    getUser();
  }

  getUser() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    user = await LocalStorage.getUser();
    var emp = await applicationBloc.getEmployeeDetailById(widget.employeeId);
    empName = emp['name'].toString();
    setState(() {});
  }

  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "History: ",
                              style:
                                  FontStyle(18, Colors.black, FontWeight.bold),
                              children: [
                            TextSpan(
                                text: empName,
                                style: FontStyle(
                                    12, Colors.black, FontWeight.w500)),
                          ])),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 1.5)
                            ],
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: Text(
                          "Date: ${resultDate.isEmpty ? "N/A" : resultDate}",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyle(14, Colors.white, FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: Constants.screenHeight(context) * 0.45,
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
                            height: Constants.screenHeight(context) * 0.45,
                            width: Constants.screenWidth(context),
                            child: FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                center: fenceList.first,
                                zoom: _zoomValue,
                              ),
                              layers: [
                                TileLayerOptions(urlTemplate: Constants.mapURL),
                                PolygonLayerOptions(polygons: allFences),
                                PolylineLayerOptions(polylines: allLines),
                                MarkerLayerOptions(markers: [
                                  Marker(
                                      point: markerPoint,
                                      builder: (BuildContext context) {
                                        return Container(
                                          decoration:
                                              const BoxDecoration(boxShadow: [
                                            BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 10),
                                          ]),
                                          child: Icon(
                                            Icons.circle_rounded,
                                            size: 20,
                                            color: markerPointColor,
                                          ),
                                        );
                                      })
                                ])
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
                  SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date Range",
                        style: FontStyle(16, Colors.black, FontWeight.w700),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            dateinstringFrom = "From";
                            dateinstringTo = "To";
                            fromTime = "From -:-";
                            toTime = "To -:-";
                            allFences.clear();
                            allLines.clear();
                            fence_colors.clear();
                            resultDate = '';
                            totalresults = "0";
                            markerPoint = LatLng(0, 0);
                            markerPointColor = Colors.black;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "Reset",
                            style: FontStyle(14, Colors.white, FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          var today = DateTime.now();
                          dateinstringFrom =
                              '${today.day}/${today.month}/${today.year}';
                          await showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                    actions: [
                                      SizedBox(
                                        height: 180,
                                        child: CupertinoDatePicker(
                                          onDateTimeChanged: (date) {
                                            dateinstringFrom =
                                                '${date.day}/${date.month}/${date.year}';
                                          },
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime: DateTime.now(),
                                        ),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            dateinstringFrom = "From";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Done"),
                                    ),
                                  ));
                          setState(() {});
                        },
                        child: Container(
                          width: Constants.screenWidth(context) * 0.15,
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.date_range, size: 18),
                                  Expanded(
                                    child: Text(
                                      dateinstringFrom,
                                      textAlign: TextAlign.center,
                                      style: FontStyle(
                                          14, Colors.black, FontWeight.w400),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 1.5)
                            ],
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const Text("---"),
                      InkWell(
                        onTap: () async {
                          var today = DateTime.now();
                          dateinstringTo =
                              '${today.day}/${today.month}/${today.year}';
                          await showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                    actions: [
                                      SizedBox(
                                        height: 180,
                                        child: CupertinoDatePicker(
                                          onDateTimeChanged: (date) {
                                            setState(() {
                                              dateinstringTo =
                                                  '${date.day}/${date.month}/${date.year}';
                                            });
                                          },
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime: DateTime.now(),
                                        ),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            dateinstringTo = "To";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Done"),
                                    ),
                                  ));
                          setState(() {});
                        },
                        child: Container(
                          width: Constants.screenWidth(context) * 0.15,
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.date_range, size: 18),
                                  Expanded(
                                    child: Text(
                                      dateinstringTo,
                                      textAlign: TextAlign.center,
                                      style: FontStyle(
                                          14, Colors.black, FontWeight.w400),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 1.5)
                            ],
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    "Time Range",
                    style: FontStyle(16, Colors.black, FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          var today = DateTime.now();
                          fromTime = '${today.hour}:${today.minute}';
                          await showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                    actions: [
                                      SizedBox(
                                        height: 180,
                                        child: CupertinoDatePicker(
                                          onDateTimeChanged: (time) {
                                            setState(() {
                                              var hour = time.hour <= 9
                                                  ? "0${time.hour}"
                                                  : time.hour;
                                              var mint = time.minute <= 9
                                                  ? "0${time.minute}"
                                                  : time.minute;
                                              fromTime = '$hour:$mint';
                                            });
                                          },
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: DateTime.now(),
                                        ),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            fromTime = "From -:-";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Done"),
                                    ),
                                  ));
                          setState(() {});
                        },
                        child: Container(
                          width: Constants.screenWidth(context) * 0.15,
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  fromTime,
                                  style: FontStyle(
                                      14, Colors.black, FontWeight.w400),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.watch_later_rounded, size: 18),
                            ],
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 1.5)
                            ],
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const Text("---"),
                      InkWell(
                        onTap: () async {
                          var today = DateTime.now();
                          toTime = '${today.hour}:${today.minute}';
                          await showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                    actions: [
                                      SizedBox(
                                        height: 180,
                                        child: CupertinoDatePicker(
                                          onDateTimeChanged: (time) {
                                            setState(() {
                                              var hour = time.hour <= 9
                                                  ? "0${time.hour}"
                                                  : time.hour;
                                              var mint = time.minute <= 9
                                                  ? "0${time.minute}"
                                                  : time.minute;
                                              toTime = '$hour:$mint';
                                            });
                                          },
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: DateTime.now(),
                                        ),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            toTime = "To -:-";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Done"),
                                    ),
                                  ));
                          setState(() {});
                        },
                        child: Container(
                          width: Constants.screenWidth(context) * 0.15,
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  toTime,
                                  style: FontStyle(
                                      14, Colors.black, FontWeight.w400),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.watch_later_rounded, size: 18),
                            ],
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 1.5)
                            ],
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          try {
                            var selected = await showModalBottomSheet(
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
                                        child: SearchResultOverview(
                                          records: locationsResult,
                                        )),
                                  );
                                });
                            if (selected != null) {
                              resultDate = selected['location'].date.toString();
                              allFences.clear();
                              allLines.clear();
                              markers.clear();
                              List<LatLng> latlng = [];
                              for (int i = 0;
                                  i < selected['location'].locations.length;
                                  i++) {
                                // if (selected['location']
                                //         .locations[i]
                                //         .inFence
                                //         .toString() ==
                                //     "false") {
                                //   markerPointColor = Colors.red;
                                // }
                                print(
                                    selected['location'].locations[i].inFence);
                                latlng.add(LatLng(
                                    double.parse(selected['location']
                                        .locations[i]
                                        .lat
                                        .toString()),
                                    double.parse(selected['location']
                                        .locations[i]
                                        .lng
                                        .toString())));
                              }
                              markerPointColor = selected['location']
                                      .locations[(selected['location']
                                              .locations
                                              .length -
                                          1)]
                                      .inFence
                                  ? Colors.black
                                  : Colors.red;
                              allLines.add(Polyline(
                                  strokeWidth: 5,
                                  points: latlng,
                                  isDotted: true,
                                  color: Colors.black));
                              center = latlng.last;
                              markerPoint = latlng.last;
                              mapController.move(center, _zoomValue);
                              latlng = [];
                              for (int i = 0;
                                  i < selected['fence'].points.length;
                                  i++) {
                                latlng.add(LatLng(
                                    double.parse(selected['fence']
                                        .points[i]
                                        .lat
                                        .toString()),
                                    double.parse(selected['fence']
                                        .points[i]
                                        .lng
                                        .toString())));
                              }
                              allFences.add(Polygon(
                                  points: latlng,
                                  borderColor: Constants.primaryColor,
                                  borderStrokeWidth: 4,
                                  color: Colors.transparent));
                              setState(() {});
                            }
                          } catch (ex) {}
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "Total results ${locationsResult.length}",
                            style: FontStyle(14, Colors.white, FontWeight.w500),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            var selected = await showModalBottomSheet(
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
                                        child: ViewLocatiosOverview(
                                          employeeId: widget.employeeId,
                                        )),
                                  );
                                });
                            if (selected != null) {
                              resultDate = selected['location'].date.toString();
                              allFences.clear();
                              allLines.clear();
                              markers.clear();
                              List<LatLng> latlng = [];
                              for (int i = 0;
                                  i < selected['location'].locations.length;
                                  i++) {
                                // if (selected['location']
                                //         .locations[i]
                                //         .inFence
                                //         .toString() ==
                                //     "false") {
                                //   markerPointColor = Colors.red;
                                // }
                                print(
                                    selected['location'].locations[i].inFence);
                                latlng.add(LatLng(
                                    double.parse(selected['location']
                                        .locations[i]
                                        .lat
                                        .toString()),
                                    double.parse(selected['location']
                                        .locations[i]
                                        .lng
                                        .toString())));
                              }
                              markerPointColor = selected['location']
                                      .locations[(selected['location']
                                              .locations
                                              .length -
                                          1)]
                                      .inFence
                                  ? Colors.black
                                  : Colors.red;
                              allLines.add(Polyline(
                                  strokeWidth: 5,
                                  points: latlng,
                                  isDotted: true,
                                  color: Colors.black));
                              center = latlng.last;
                              markerPoint = latlng.last;
                              mapController.move(center, _zoomValue);
                              latlng = [];
                              for (int i = 0;
                                  i < selected['fence'].points.length;
                                  i++) {
                                latlng.add(LatLng(
                                    double.parse(selected['fence']
                                        .points[i]
                                        .lat
                                        .toString()),
                                    double.parse(selected['fence']
                                        .points[i]
                                        .lng
                                        .toString())));
                              }
                              allFences.add(Polygon(
                                  points: latlng,
                                  borderColor: Constants.primaryColor,
                                  borderStrokeWidth: 4,
                                  color: Colors.transparent));
                              setState(() {});
                            }
                          } catch (ex) {
                            print(ex);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "View locations overview",
                            style: FontStyle(14, Colors.white, FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  )
                  // Container(
                  //   width: Constants.screenWidth(context),
                  //   height: 55,
                  //   child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: fence_colors.length,
                  //       itemBuilder: ((context, index) {
                  //         return Container(
                  //           alignment: Alignment.center,
                  //           padding: const EdgeInsets.all(15),
                  //           color: fence_colors[index],
                  //           margin: const EdgeInsets.all(5),
                  //           child: Text(
                  //             "17",
                  //             style:
                  //                 FontStyle(15, Colors.white, FontWeight.bold),
                  //           ),
                  //         );
                  //       })),
                  // )
                ],
              ),
            ),
          ),
          NavBox(
              buttonText: applicationBloc.loading ? "Please wait..." : "Apply",
              onPress: () async {
                if (dateinstringFrom == "From" &&
                    dateinstringTo == "To" &&
                    fromTime == "From -:-" &&
                    toTime == "To -:-") {
                  Constants.showSnackBar(
                      context, "Please select \"Date or time ranges\".", false);
                  return;
                }

                if (dateinstringFrom != "From" &&
                    dateinstringTo == "To" &&
                    fromTime == "From -:-" &&
                    toTime == "To -:-") {
                  print("One Date");
                  allFences.clear();
                  allLines.clear();
                  fence_colors.clear();
                  var data = await applicationBloc.getEmployeeLocationsOnDate(
                      dateinstringFrom, widget.employeeId);
                  if (data == null) {
                    Constants.showSnackBar(
                        context, "No locations found", false);
                    return;
                  }
                  List<LatLng> latlng = [];
                  for (var loc in data['locations']) {
                    latlng.add(LatLng(double.parse(loc['lat'].toString()),
                        double.parse(loc['lng'].toString())));
                  }

                  allLines.add(Polyline(
                      strokeWidth: 5,
                      points: latlng,
                      isDotted: true,
                      color: Colors.black));

                  print(data);
                  center = latlng.last;
                  mapController.move(center, _zoomValue);
                  latlnglist.clear();
                  var fenceData = await applicationBloc
                      .getFenceById(data['fence'].toString());
                  for (var point in fenceData['points']) {
                    print(point);
                    latlnglist.add(LatLng(double.parse(point['lat'].toString()),
                        double.parse(point['lng'].toString())));
                  }
                  print(latlnglist.length);
                  allFences.add(Polygon(
                      points: latlnglist,
                      borderColor: Constants.primaryColor,
                      borderStrokeWidth: 4,
                      color: Colors.transparent));
                  setState(() {});
                }
                if (dateinstringFrom != "From" &&
                    dateinstringTo != "To" &&
                    fromTime == "From -:-" &&
                    toTime == "To -:-") {
                  print("Two dates");
                  allFences.clear();
                  allLines.clear();
                  fence_colors.clear();
                  List<dynamic> data =
                      await applicationBloc.getEmployeeLocationsOnDateRange(
                          dateinstringFrom, dateinstringTo, widget.employeeId);
                  if (data == null) {
                    Constants.showSnackBar(
                        context, "No locations found", false);
                    return;
                  }
                  List<LatLng> latlng = [];
                  for (var item in data) {
                    for (var loc in item['location']['locations']) {
                      latlng.add(LatLng(double.parse(loc['lat'].toString()),
                          double.parse(loc['lng'].toString())));
                    }
                    allLines.add(Polyline(
                        strokeWidth: 5,
                        points: latlng,
                        isDotted: true,
                        color: Colors.black));
                    center = latlng.last;
                    mapController.move(center, _zoomValue);
                    latlng = [];
                    var fence = await applicationBloc
                        .getFenceById(item['location']['fence'].toString());

                    for (var point in fence['points']) {
                      latlng.add(LatLng(double.parse(point['lat'].toString()),
                          double.parse(point['lng'].toString())));
                    }
                    Color color = Colors
                        .primaries[Random().nextInt(Colors.primaries.length)];
                    fence_colors.add(color);
                    allFences.add(Polygon(
                        points: latlng,
                        borderColor: color,
                        borderStrokeWidth: 4,
                        color: Colors.transparent));
                    latlng = [];
                    locationsResult.add({
                      "location":
                          EmployeeLocationModel.fromJson(item['location']),
                      "fence": FenceModel.fromJson(fence)
                    });
                  }
                  if (allLines.length == 0) {
                    Constants.showSnackBar(
                        context, "No locations found", false);
                  }
                  setState(() {});

                  return;
                }
                if (dateinstringFrom != "From" &&
                    dateinstringTo == "To" &&
                    fromTime != "From -:-" &&
                    toTime != "To -:-") {
                  Map<String, dynamic> data =
                      await applicationBloc.getEmployeeLocationsOnTimeRange(
                          dateinstringFrom,
                          fromTime,
                          toTime,
                          widget.employeeId);
                  if (data == null) {
                    Constants.showSnackBar(
                        context, "No locations found", false);
                    return;
                  }
                  allFences = [];
                  allLines = [];
                  fence_colors.clear();
                  List<LatLng> latlng = [];
                  for (var loc in data['location']['locations']) {
                    latlng.add(LatLng(double.parse(loc['lat'].toString()),
                        double.parse(loc['lng'].toString())));
                  }
                  allLines.add(Polyline(
                      strokeWidth: 5,
                      points: latlng,
                      isDotted: true,
                      color: Colors.black));
                  center = latlng.last;
                  mapController.move(center, _zoomValue);
                  latlng = [];
                  for (var point in data['fence']['points']) {
                    latlng.add(LatLng(double.parse(point['lat'].toString()),
                        double.parse(point['lng'].toString())));
                  }
                  Color color = Colors
                      .primaries[Random().nextInt(Colors.primaries.length)];
                  fence_colors.add(color);
                  allFences.add(Polygon(
                      points: latlng,
                      borderColor: color,
                      borderStrokeWidth: 4,
                      color: Colors.transparent));
                  latlng = [];
                  if (allLines.length == 0) {
                    Constants.showSnackBar(
                        context, "No locations found", false);
                  }
                  setState(() {});
                  return;
                }
                if (dateinstringFrom != "From" &&
                    dateinstringTo != "To" &&
                    fromTime != "From -:-" &&
                    toTime != "To -:-") {
                  print(await applicationBloc
                      .getEmployeeLocationsOnDateAndTimeRange(dateinstringFrom,
                          dateinstringTo, fromTime, toTime, widget.employeeId));
                  return;
                }
                if (dateinstringFrom == "From" &&
                    dateinstringTo == "To" &&
                    fromTime != "From -:-" &&
                    toTime != "To -:-") {
                  var now = DateTime.now();
                  var day = now.day < 9 ? "0${now.day}" : now.day;
                  var month = now.month < 9 ? "0${now.month}" : now.month;
                  String today = "$day/$month/${now.year}";
                  print(today);
                  return;
                }
              }),
        ],
      ),
    );
  }
}

class ViewLocatiosOverview extends StatefulWidget {
  String employeeId;
  ViewLocatiosOverview({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<ViewLocatiosOverview> createState() => _ViewLocatiosOverviewState();
}

class _ViewLocatiosOverviewState extends State<ViewLocatiosOverview> {
  //List<EmployeeLocationModel> locations = [];
  List<Map<String, dynamic>> locations = [];
  @override
  void initState() {
    _getLocations();
    super.initState();
  }

  _getLocations() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    var data =
        await applicationBloc.getEmployeesAllLocations(widget.employeeId);
    locations.clear();
    for (var item in data) {
      var fence = await applicationBloc.getFenceById(item['fence'].toString());
      locations.add({
        "location": EmployeeLocationModel.fromJson(item),
        "fence": FenceModel.fromJson(fence)
      });
    }
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
                  'Locations overview',
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
                  itemCount: locations.length,
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
                            Text(locations[index]['fence'].name.toString(),
                                style: FontStyle(18, Constants.primaryColor,
                                    FontWeight.w500)),
                            RichText(
                                text: TextSpan(
                                    text: "Date: ",
                                    style: FontStyle(
                                        12, Colors.black, FontWeight.w500),
                                    children: [
                                  TextSpan(
                                      text:
                                          "  ${locations[index]['location'].date.toString()}",
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

class SearchResultOverview extends StatefulWidget {
  List<Map<String, dynamic>> records;
  SearchResultOverview({Key? key, required this.records}) : super(key: key);

  @override
  State<SearchResultOverview> createState() => _SearchResultOverviewState();
}

class _SearchResultOverviewState extends State<SearchResultOverview> {
  @override
  void initState() {
    for (var item in widget.records) {
      print(item['fence'].name);
    }
    super.initState();
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
                  'Locations overview',
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
                  itemCount: widget.records.length,
                  padding: const EdgeInsets.only(top: 10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, widget.records[index]);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: Constants.screenWidth(context),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.records[index]['fence'].name.toString(),
                                style: FontStyle(18, Constants.primaryColor,
                                    FontWeight.w500)),
                            RichText(
                                text: TextSpan(
                                    text: "Date: ",
                                    style: FontStyle(
                                        12, Colors.black, FontWeight.w500),
                                    children: [
                                  TextSpan(
                                      text:
                                          "  ${widget.records[index]['location'].date}",
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
