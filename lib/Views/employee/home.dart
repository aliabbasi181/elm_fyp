import 'package:elm_fyp/Models/AssignedFenceModel.dart';
import 'package:elm_fyp/Models/EmpoloyeeLocationModel.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/employee/employee_fence_detail.dart';
import 'package:elm_fyp/Views/employee/employee_locations_log.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:provider/provider.dart';

import '../../BLoc/application_bloc.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({Key? key}) : super(key: key);

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  List<LatLng> latlnglist = <LatLng>[];
  List<LatLng> fenceList = <LatLng>[];
  MapController mapController = MapController();
  List<LatLng> userPoints = <LatLng>[];
  List<Marker> marker = [];
  LatLng center = LatLng(33.6635, 73.0841);
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  String dateinstringFrom = "From";
  String dateinstringTo = "To";
  String fromTime = "From:- 09:30 AM";
  String toTime = "To:- 06:30 PM";
  String pickFence = "Select Location";
  List<AssignedFenceModel> assignedFences = [];
  FenceModel todaysFence = FenceModel(name: "Loading...");
  double _zoomValue = 13;
  EmployeeLocationModel employeeLocationModel = EmployeeLocationModel();
  @override
  void initState() {
    _getAssignedFences();
    super.initState();
  }

  _getTodayLocations() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    var today = DateTime.now();
    var data = await applicationBloc.getEmployeeLocationsOnDate(
        "${today.day}/${today.month}/${today.year}",
        Constants.employee.sId.toString());
    if (data != null) {
      latlnglist.clear();
      for (var item in data['locations']) {
        latlnglist.add(LatLng(item['lat'], item['lng']));
      }
      employeeLocationModel = EmployeeLocationModel.fromJson(data);
    }
    setState(() {});
  }

  _getAssignedFences() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    List<dynamic> data = await applicationBloc.getAssignedFences();
    for (var item in data) {
      assignedFences.add(AssignedFenceModel(
        sId: item['_id'],
        employee: item['employee'],
        region: item['region'],
        dateFrom: item['dateFrom'],
        dateTo: item['dateTo'],
        startTime: item['startTime'],
        endTime: item['endTime'],
        user: item['user'],
        createdAt: item['createdAt'],
      ));
    }
    await applicationBloc.employeeDetail();
    print(Constants.employee);
    await _getTodaysAssignedFence();
  }

  _getTodaysAssignedFence() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    var data;
    var today = DateTime.now();
    var day = int.parse(today.day.toString()) < 10
        ? "0" + today.day.toString()
        : today.day;
    var month = int.parse(today.month.toString()) < 10
        ? "0" + today.month.toString()
        : today.month;
    var dateInString = '${today.year}-$month-$day';
    DateTime todayDate = DateTime.parse(dateInString);
    var timeInString = '${today.hour}:${today.minute}';
    AssignedFenceModel current = AssignedFenceModel();
    for (var item in assignedFences) {
      var date = item.dateFrom.toString().split('/');
      day = int.parse(date[0]) < 10 ? "0" + date[0] : date[0];
      month = int.parse(date[1]) < 10 ? "0" + date[1] : date[1];
      DateTime dateFrom = DateTime.parse("${date[2]}-$month-$day");
      date = item.dateTo.toString().split('/');
      day = int.parse(date[0]) < 10 ? "0" + date[0] : date[0];
      month = int.parse(date[1]) < 10 ? "0" + date[1] : date[1];
      DateTime dateTo = DateTime.parse("${date[2]}-$month-$day");
      print("$dateFrom - $dateTo");
      if (dateFrom == todayDate || dateTo == todayDate) {
        print("Compared");
        current = item;
      } else if (todayDate.isBefore(dateTo) && todayDate.isAfter(dateFrom)) {
        print("between");
        current = item;
      } else {
        print("past");
      }
    }
    if (current.region != null) {
      _getTodayLocations();
      data = await applicationBloc.getFenceById(current.region.toString());
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
      //mapController.move(LatLng(lat, lng), 14.5);
    } else {
      print("no fence assigned for today");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
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
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                            Constants.employee.name == null
                                ? "Fetcting name..."
                                : Constants.employee.name.toString(),
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
                              Constants.employee.designation == null
                                  ? "Fetcting designation..."
                                  : Constants.employee.designation.toString(),
                              style:
                                  FontStyle(14, Colors.white, FontWeight.w500),
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(
                    height: Constants.screenWidth(context) * 0.015,
                  ),
                  Container(
                    height: Constants.screenHeight(context) * 0.52,
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
                            height: Constants.screenHeight(context) * 0.52,
                            width: Constants.screenWidth(context),
                            // child: FlutterMap(
                            //   mapController: mapController,
                            //   options: MapOptions(
                            //     center: center,
                            //     zoom: _zoomValue,
                            //     onTap: (position, latlng) async {
                            //       var today = DateTime.now();
                            //       var dateInString =
                            //           '${today.day}/${today.month}/${today.year}';
                            //       var timeInString =
                            //           '${today.hour}:${today.minute}';
                            //       await applicationBloc.saveUserLocation(latlng,
                            //           dateInString, timeInString, context);
                            //       setState(() {
                            //         latlnglist.add(LatLng(
                            //             latlng.latitude, latlng.longitude));
                            //       });
                            //     },
                            //   ),
                            //   layers: [
                            //     TileLayerOptions(
                            //       urlTemplate: Constants.mapURL,
                            //     ),
                            //     PolylineLayerOptions(polylines: [
                            //       Polyline(
                            //           color: Constants.primaryColor,
                            //           strokeWidth: 8,
                            //           isDotted: true,
                            //           points: latlnglist)
                            //     ]),
                            //     PolylineLayerOptions(polylines: [
                            //       Polyline(
                            //           color: Colors.black,
                            //           strokeWidth: 5,
                            //           points: fenceList)
                            //     ]),
                            //     MarkerLayerOptions(
                            //       markers: [
                            //         Marker(
                            //           point: latlnglist.isNotEmpty
                            //               ? latlnglist.last
                            //               : LatLng(0, 0),
                            //           builder: (ctx) => Container(
                            //             decoration:
                            //                 const BoxDecoration(boxShadow: [
                            //               BoxShadow(
                            //                   color: Colors.black54,
                            //                   blurRadius: 10),
                            //             ]),
                            //             child: const Icon(
                            //               Icons.circle_rounded,
                            //               size: 20,
                            //               color: Colors.black,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          List<FenceModel> fences = [];
                          for (var item in assignedFences) {
                            var data = await applicationBloc
                                .getFenceById(item.region.toString());
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
                          if (employeeLocationModel.locations == null) {
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmployeeLocationsLog(
                                        name:
                                            Constants.employee.name.toString(),
                                        assignedFence:
                                            todaysFence.name.toString(),
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
                  )
                  // InkWell(
                  //   onTap: () async {
                  //     try {
                  //       // pickFence = await showModalBottomSheet(
                  //       //     context: context,
                  //       //     isScrollControlled: true,
                  //       //     backgroundColor: Colors.transparent,
                  //       //     builder: (context) {
                  //       //       return SafeArea(
                  //       //         bottom: false,
                  //       //         child: Container(
                  //       //           margin: EdgeInsets.only(
                  //       //               top:
                  //       //                   Constants.screenHeight(context) * 0.5),
                  //       //           width: Constants.screenWidth(context),
                  //       //           height: Constants.screenHeight(context),
                  //       //           decoration: const BoxDecoration(
                  //       //               color: Colors.white,
                  //       //               borderRadius: BorderRadius.only(
                  //       //                   topLeft: Radius.circular(20),
                  //       //                   topRight: Radius.circular(20))),
                  //       //           child: const PickFence(),
                  //       //         ),
                  //       //       );
                  //       //     });
                  //     } catch (ex) {}
                  //     setState(() {});
                  //   },
                  //   child: Container(
                  //     margin: const EdgeInsets.only(bottom: 5),
                  //     padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.near_me_rounded,
                  //           size: 20,
                  //         ),
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         Expanded(
                  //           child: Text(
                  //               pickFence == "Select Fence"
                  //                   ? "Select Fence"
                  //                   : pickFence,
                  //               style: FontStyle(
                  //                   14, Colors.black, FontWeight.w400)),
                  //         ),
                  //         const Icon(Icons.keyboard_arrow_down_rounded),
                  //       ],
                  //     ),
                  //     decoration: BoxDecoration(
                  //       boxShadow: [
                  //         BoxShadow(color: Colors.black, blurRadius: 1.5)
                  //       ],
                  //       color: const Color.fromRGBO(255, 255, 255, 1),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  // ),

                  // Text(
                  //   "Date Range",
                  //   style: FontStyle(16, Colors.black, FontWeight.w700),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         var today = DateTime.now();
                  //         setState(() {
                  //           dateinstringFrom =
                  //               '${today.day}/${today.month}/${today.year}';
                  //           showCupertinoModalPopup(
                  //               context: context,
                  //               builder: (context) => CupertinoActionSheet(
                  //                     actions: [
                  //                       SizedBox(
                  //                         height: 180,
                  //                         child: CupertinoDatePicker(
                  //                           //minimumDate: DateTime.now(),
                  //                           //maximumDate: DateTime.now(),
                  //                           maximumYear: DateTime.now().year,
                  //                           onDateTimeChanged: (date) {
                  //                             dateinstringFrom =
                  //                                 '${date.day}/${date.month}/${date.year}';
                  //                           },
                  //                           mode: CupertinoDatePickerMode.date,
                  //                           initialDateTime: DateTime.now(),
                  //                         ),
                  //                       )
                  //                     ],
                  //                     cancelButton: CupertinoActionSheetAction(
                  //                       onPressed: () {
                  //                         Navigator.pop(context);
                  //                       },
                  //                       child: const Text("Done"),
                  //                     ),
                  //                   ));
                  //         });
                  //       },
                  //       child: Container(
                  //         width: Constants.screenWidth(context) * 0.2,
                  //         margin: const EdgeInsets.only(bottom: 5),
                  //         padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //         child: Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Icon(Icons.date_range, size: 18),
                  //                 Expanded(
                  //                   child: Text(
                  //                     dateinstringFrom,
                  //                     textAlign: TextAlign.center,
                  //                     style: FontStyle(
                  //                         14, Colors.black, FontWeight.w400),
                  //                     softWrap: true,
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //           boxShadow: [
                  //             BoxShadow(color: Colors.black, blurRadius: 1.5)
                  //           ],
                  //           color: const Color.fromRGBO(255, 255, 255, 1),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //     const Text("---"),
                  //     InkWell(
                  //       onTap: () {
                  //         var today = DateTime.now();
                  //         dateinstringTo =
                  //             '${today.day}/${today.month}/${today.year}';
                  //         showCupertinoModalPopup(
                  //             context: context,
                  //             builder: (context) => CupertinoActionSheet(
                  //                   actions: [
                  //                     SizedBox(
                  //                       height: 180,
                  //                       child: CupertinoDatePicker(
                  //                         maximumYear: DateTime.now().year,
                  //                         onDateTimeChanged: (date) {
                  //                           setState(() {
                  //                             dateinstringTo =
                  //                                 '${date.day}/${date.month}/${date.year}';
                  //                           });
                  //                         },
                  //                         mode: CupertinoDatePickerMode.date,
                  //                         initialDateTime: DateTime.now(),
                  //                       ),
                  //                     )
                  //                   ],
                  //                   cancelButton: CupertinoActionSheetAction(
                  //                     onPressed: () {
                  //                       Navigator.pop(context);
                  //                     },
                  //                     child: const Text("Done"),
                  //                   ),
                  //                 ));
                  //         setState(() {});
                  //       },
                  //       child: Container(
                  //         width: Constants.screenWidth(context) * 0.2,
                  //         margin: const EdgeInsets.only(bottom: 5),
                  //         padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //         child: Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Icon(Icons.date_range, size: 18),
                  //                 Expanded(
                  //                   child: Text(
                  //                     dateinstringTo,
                  //                     textAlign: TextAlign.center,
                  //                     style: FontStyle(
                  //                         14, Colors.black, FontWeight.w400),
                  //                     softWrap: true,
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //           boxShadow: [
                  //             BoxShadow(color: Colors.black, blurRadius: 1.5)
                  //           ],
                  //           color: const Color.fromRGBO(255, 255, 255, 1),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Text(
                  //   "Time Range",
                  //   style: FontStyle(16, Colors.black, FontWeight.w700),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         var today = DateTime.now();
                  //         fromTime = '${today.hour}:${today.minute}';
                  //         showCupertinoModalPopup(
                  //             context: context,
                  //             builder: (context) => CupertinoActionSheet(
                  //                   actions: [
                  //                     SizedBox(
                  //                       height: 180,
                  //                       child: CupertinoDatePicker(
                  //                         minimumDate: DateTime.now(),
                  //                         maximumDate: DateTime(2030),
                  //                         onDateTimeChanged: (time) {
                  //                           setState(() {
                  //                             fromTime =
                  //                                 '${time.hour}:${time.minute}';
                  //                           });
                  //                         },
                  //                         mode: CupertinoDatePickerMode.time,
                  //                         initialDateTime: DateTime.now(),
                  //                       ),
                  //                     )
                  //                   ],
                  //                   cancelButton: CupertinoActionSheetAction(
                  //                     onPressed: () {
                  //                       Navigator.pop(context);
                  //                     },
                  //                     child: const Text("Done"),
                  //                   ),
                  //                 ));
                  //         setState(() {});
                  //       },
                  //       child: Container(
                  //         width: Constants.screenWidth(context) * 0.2,
                  //         margin: const EdgeInsets.only(bottom: 5),
                  //         padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //         child: Row(
                  //           children: [
                  //             Expanded(
                  //               child: Text(
                  //                 fromTime,
                  //                 style: FontStyle(
                  //                     14, Colors.black, FontWeight.w400),
                  //                 softWrap: true,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //             Icon(Icons.watch_later_rounded, size: 18),
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //           boxShadow: [
                  //             BoxShadow(color: Colors.black, blurRadius: 1.5)
                  //           ],
                  //           color: const Color.fromRGBO(255, 255, 255, 1),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //     const Text("---"),
                  //     InkWell(
                  //       onTap: () {
                  //         var today = DateTime.now();
                  //         toTime = '${today.hour}:${today.minute}';
                  //         showCupertinoModalPopup(
                  //             context: context,
                  //             builder: (context) => CupertinoActionSheet(
                  //                   actions: [
                  //                     SizedBox(
                  //                       height: 180,
                  //                       child: CupertinoDatePicker(
                  //                         minimumDate: DateTime.now(),
                  //                         maximumDate: DateTime(2030),
                  //                         onDateTimeChanged: (time) {
                  //                           setState(() {
                  //                             toTime =
                  //                                 '${time.hour}:${time.minute}';
                  //                           });
                  //                         },
                  //                         mode: CupertinoDatePickerMode.time,
                  //                         initialDateTime: DateTime.now(),
                  //                       ),
                  //                     )
                  //                   ],
                  //                   cancelButton: CupertinoActionSheetAction(
                  //                     onPressed: () {
                  //                       Navigator.pop(context);
                  //                     },
                  //                     child: const Text("Done"),
                  //                   ),
                  //                 ));
                  //         setState(() {});
                  //       },
                  //       child: Container(
                  //         width: Constants.screenWidth(context) * 0.2,
                  //         margin: const EdgeInsets.only(bottom: 5),
                  //         padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //         child: Row(
                  //           children: [
                  //             Expanded(
                  //               child: Text(
                  //                 toTime,
                  //                 style: FontStyle(
                  //                     14, Colors.black, FontWeight.w400),
                  //                 softWrap: true,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //             Icon(Icons.watch_later_rounded, size: 18),
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //           boxShadow: [
                  //             BoxShadow(color: Colors.black, blurRadius: 1.5)
                  //           ],
                  //           color: const Color.fromRGBO(255, 255, 255, 1),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // // Row(
                  // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // //   children: [
                  // //     InkWell(
                  // //       onTap: () {},
                  // //       child: Container(
                  // //         width: Constants.screenWidth(context) * 0.41,
                  // //         margin: const EdgeInsets.only(bottom: 5),
                  // //         padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                  // //         child: ListTile(
                  // //           // trailing: const Icon(Icons.watch_later_rounded),
                  // //           title: Text(
                  // //             fromTime,
                  // //             textAlign: TextAlign.center,
                  // //           ),
                  // //         ),
                  // //         decoration: BoxDecoration(
                  // //             color: Colors.white,
                  // //             borderRadius: BorderRadius.circular(15)),
                  // //       ),
                  // //     ),
                  // //     InkWell(
                  // //       onTap: () {},
                  // //       child: Container(
                  // //         width: Constants.screenWidth(context) * 0.41,
                  // //         margin: const EdgeInsets.only(bottom: 5),
                  // //         padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                  // //         child: ListTile(
                  // //           // trailing: const Icon(Icons.watch_later_rounded),
                  // //           title: Text(
                  // //             toTime,
                  // //             textAlign: TextAlign.center,
                  // //           ),
                  // //         ),
                  // //         decoration: BoxDecoration(
                  // //             color: Colors.white,
                  // //             borderRadius: BorderRadius.circular(15)),
                  // //       ),
                  // //     ),
                  // //   ],
                  // // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     const SizedBox(
                  //       width: 5,
                  //     ),
                  //     ElevatedButton.icon(
                  //       onPressed: () async {
                  //         // await LocalStorage.removeUser();
                  //         // Navigator.pushAndRemoveUntil(
                  //         //     context,
                  //         //     MaterialPageRoute(
                  //         //         builder: (context) => const Login()),
                  //         //     (route) => false);
                  //         var user = await LocalStorage.getUser();
                  //         print(dateinstringFrom);
                  //         applicationBloc.getEmployeeLocationsOnDate(
                  //             dateinstringFrom, user[0].toString());
                  //       },
                  //       style: ButtonStyle(
                  //           backgroundColor: MaterialStateProperty.resolveWith(
                  //               (states) => Constants.primaryColor)),
                  //       icon: const Icon(Icons.history),
                  //       label: const Text(
                  //         "History",
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowAssignedFences extends StatefulWidget {
  List<FenceModel> fences;
  List<AssignedFenceModel> assignedFences;
  ShowAssignedFences(
      {Key? key, required this.fences, required this.assignedFences})
      : super(key: key);

  @override
  State<ShowAssignedFences> createState() => _ShowAssignedFencesState();
}

class _ShowAssignedFencesState extends State<ShowAssignedFences> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigned Fences',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const Divider(
              color: Color(0XFFFeceef0),
              thickness: 1,
              height: 10,
            ),
            Container(
              height: Constants.screenHeight(context) * 0.45,
              child: ListView.builder(
                  itemCount: widget.fences.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          minLeadingWidth: 0,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmployeeFenceDetail(
                                          fence: widget.fences[index],
                                          assignedFenc:
                                              widget.assignedFences[index],
                                        )));
                          },
                          title: Text(
                            widget.fences[index].name.toString(),
                            style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Constants.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      widget.assignedFences[index].dateFrom
                                          .toString(),
                                      style: FontStyle(
                                          14, Colors.white, FontWeight.w500),
                                    ),
                                  ),
                                  const Text("  - To -  "),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Constants.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      widget.assignedFences[index].dateTo
                                          .toString(),
                                      style: FontStyle(
                                          14, Colors.white, FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Constants.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      widget.assignedFences[index].startTime
                                          .toString(),
                                      style: FontStyle(
                                          14, Colors.white, FontWeight.w500),
                                    ),
                                  ),
                                  const Text("  - To -  "),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Constants.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      widget.assignedFences[index].endTime
                                          .toString(),
                                      style: FontStyle(
                                          14, Colors.white, FontWeight.w500),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color(0XFFFeceef0),
                          thickness: 1,
                          height: 0,
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
