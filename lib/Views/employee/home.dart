import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:elm_fyp/Views/widgets.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({Key? key}) : super(key: key);

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  List<LatLng> latlnglist = <LatLng>[];
  List<LatLng> fenceList = <LatLng>[];
  MapController mapController = MapController();
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  String dateinstring = "Select Date";
  String fromTime = "From:- 09:30 AM";
  String toTime = "To:- 06:30 PM";
  String pickFence = "Select Location";
  @override
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
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Expanded(
                              child: Text(
                            "Ali Hassan",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: Constants.screenWidth(context) * 0.015,
                  ),
                  const Text(
                    "Assigned Fence: Bilal Colony",
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
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: LatLng(33.5651, 73.0169),
                        zoom: 14,
                        onTap: (position, latlng) {
                          // print("${latlng.latitude},${latlng.longitude}");
                          // setState(() {
                          //   latlnglist.add(latlng);
                          // });
                        },
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate: Constants.mapURL,
                        ),
                        PolylineLayerOptions(polylines: [
                          Polyline(
                              color: Constants.primaryColor,
                              strokeWidth: 8,
                              isDotted: true,
                              points: latlnglist)
                        ]),
                        PolylineLayerOptions(polylines: [
                          Polyline(
                              color: Colors.black,
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
                                      color: Colors.black54, blurRadius: 10),
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
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      try {
                        // pickFence = await showModalBottomSheet(
                        //     context: context,
                        //     isScrollControlled: true,
                        //     backgroundColor: Colors.transparent,
                        //     builder: (context) {
                        //       return SafeArea(
                        //         bottom: false,
                        //         child: Container(
                        //           margin: EdgeInsets.only(
                        //               top:
                        //                   Constants.screenHeight(context) * 0.5),
                        //           width: Constants.screenWidth(context),
                        //           height: Constants.screenHeight(context),
                        //           decoration: const BoxDecoration(
                        //               color: Colors.white,
                        //               borderRadius: BorderRadius.only(
                        //                   topLeft: Radius.circular(20),
                        //                   topRight: Radius.circular(20))),
                        //           child: const PickFence(),
                        //         ),
                        //       );
                        //     });
                      } catch (ex) {}
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.fromLTRB(15, 1, 10, 1),
                      child: ListTile(
                        leading: const Icon(Icons.near_me_rounded),
                        title: Text(pickFence == "Select Fence"
                            ? "Select Fence"
                            : pickFence),
                        trailing: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                    ),
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
                                          minimumDate: DateTime.now(),
                                          maximumDate: DateTime(2030),
                                          onDateTimeChanged: (time) {
                                            setState(() {
                                              fromTime =
                                                  '${time.hour}:${time.minute}';
                                            });
                                          },
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: DateTime.now(),
                                        ),
                                      )
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
                          width: Constants.screenWidth(context) * 0.2,
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
                                          minimumDate: DateTime.now(),
                                          maximumDate: DateTime(2030),
                                          onDateTimeChanged: (time) {
                                            setState(() {
                                              toTime =
                                                  '${time.hour}:${time.minute}';
                                            });
                                          },
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: DateTime.now(),
                                        ),
                                      )
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
                          width: Constants.screenWidth(context) * 0.2,
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {},
                  //       child: Container(
                  //         width: Constants.screenWidth(context) * 0.41,
                  //         margin: const EdgeInsets.only(bottom: 5),
                  //         padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                  //         child: ListTile(
                  //           // trailing: const Icon(Icons.watch_later_rounded),
                  //           title: Text(
                  //             fromTime,
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //         decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(15)),
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {},
                  //       child: Container(
                  //         width: Constants.screenWidth(context) * 0.41,
                  //         margin: const EdgeInsets.only(bottom: 5),
                  //         padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                  //         child: ListTile(
                  //           // trailing: const Icon(Icons.watch_later_rounded),
                  //           title: Text(
                  //             toTime,
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //         decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(15)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await LocalStorage.removeUser();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (route) => false);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Constants.primaryColor)),
                        icon: const Icon(Icons.history),
                        label: const Text(
                          "History",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
