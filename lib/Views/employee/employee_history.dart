import 'dart:convert';
import 'dart:math';

import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
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
  @override
  initState() {
    super.initState();
    setState(() {});
  }

  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
                      Text(
                        "History",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyle(18, Colors.black, FontWeight.bold),
                      ),
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
                          "Name",
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
                    height: Constants.screenHeight(context) * 0.50,
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
                            height: Constants.screenHeight(context) * 0.50,
                            width: Constants.screenWidth(context),
                            child: FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                center: fenceList.first,
                                zoom: _zoomValue,
                                onTap: (position, latlng) {
                                  print(
                                      "${latlng.latitude},${latlng.longitude}");
                                  setState(() {
                                    latlnglist.add(latlng);
                                  });
                                },
                              ),
                              layers: [
                                TileLayerOptions(urlTemplate: Constants.mapURL),
                                PolygonLayerOptions(polygons: allFences),
                                PolylineLayerOptions(polylines: allLines)
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
                                    if (temp++ < 16 || temp++ == 16) {
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
                    height: 10,
                  ),
                  Text(
                    "Date Range",
                    style: FontStyle(16, Colors.black, FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          var today = DateTime.now();
                          setState(() {
                            dateinstringFrom =
                                '${today.day}/${today.month}/${today.year}';
                            showCupertinoModalPopup(
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
                          });
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
                        onTap: () {
                          var today = DateTime.now();
                          dateinstringTo =
                              '${today.day}/${today.month}/${today.year}';
                          showCupertinoModalPopup(
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
                    height: 10,
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
                        onTap: () {
                          var today = DateTime.now();
                          fromTime = '${today.hour}:${today.minute}';
                          showCupertinoModalPopup(
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
                        onTap: () {
                          var today = DateTime.now();
                          toTime = '${today.hour}:${today.minute}';
                          showCupertinoModalPopup(
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
                  Container(
                    width: Constants.screenWidth(context),
                    height: 55,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fence_colors.length,
                        itemBuilder: ((context, index) {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            color: fence_colors[index],
                            margin: const EdgeInsets.all(5),
                            child: Text(
                              "17",
                              style:
                                  FontStyle(15, Colors.white, FontWeight.bold),
                            ),
                          );
                        })),
                  )
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
                    dateinstringTo != "To" &&
                    fromTime == "From -:-" &&
                    toTime == "To -:-") {
                  allFences = [];
                  allLines = [];
                  List<dynamic> data =
                      await applicationBloc.getEmployeeLocationsOnDateRange(
                          dateinstringFrom, dateinstringTo, widget.employeeId);
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
                    latlng = [];
                    for (var point in item['fence']['points']) {
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
                  allFences = [];
                  allLines = [];
                  Map<String, dynamic> data =
                      await applicationBloc.getEmployeeLocationsOnTimeRange(
                          dateinstringFrom,
                          fromTime,
                          toTime,
                          widget.employeeId);
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
