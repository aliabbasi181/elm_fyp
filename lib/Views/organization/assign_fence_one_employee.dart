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

class AssignFenceOneEmployee extends StatefulWidget {
  EmployeeModel employee;
  AssignFenceOneEmployee({Key? key, required this.employee}) : super(key: key);

  @override
  _AssignFenceOneEmployeeState createState() => _AssignFenceOneEmployeeState();
}

class Fence {
  String name;
  Fence(this.name);
}

class _AssignFenceOneEmployeeState extends State<AssignFenceOneEmployee> {
  List<LatLng> latlnglist = <LatLng>[];
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
  @override
  initState() {
    super.initState();
    setState(() {});
    fences.add(Fence("Shamsabad"));
    fences.add(Fence("Rajabazar"));
    fences.add(Fence("Rawat"));
    fences.add(Fence("Sadar"));
    fences.add(Fence("Lignum Tower"));
    fences.add(Fence("Attok Fort"));
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
                        "Assign Fence",
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
                          widget.employee.name.toString(),
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
                    height: Constants.screenHeight(context) * 0.40,
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
                        center: fenceList.first,
                        zoom: 12,
                        onTap: (position, latlng) {
                          print("${latlng.latitude},${latlng.longitude}");
                          setState(() {
                            latlnglist.add(latlng);
                          });
                        },
                      ),
                      layers: [
                        TileLayerOptions(urlTemplate: Constants.mapURL),
                        PolygonLayerOptions(polygons: [
                          Polygon(
                              points: fenceList,
                              color: Colors.transparent,
                              borderColor: Colors.red,
                              borderStrokeWidth: 5)
                        ]),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      try {
                        fence = await showModalBottomSheet(
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
                                  child: const PickFence(),
                                ),
                              );
                            });
                        LatLng center;
                        double lat = 0, lng = 0;
                        if (fence.points != null) {
                          fenceList = [];
                          for (var item in fence.points!) {
                            lat += double.parse(item.lat.toString());
                            lng += double.parse(item.lng.toString());
                            fenceList.add(LatLng(
                                double.parse(item.lat.toString()),
                                double.parse(item.lng.toString())));
                          }
                          lat = lat / fence.points!.length;
                          lng = lng / fence.points!.length;
                        }
                        mapController.move(LatLng(lat, lng), 13.5);
                      } catch (ex) {}
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.near_me_rounded,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(fence.name.toString(),
                                style: FontStyle(
                                    14, Colors.black, FontWeight.w400)),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded),
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
                                            minimumDate: DateTime.now(),
                                            maximumDate: DateTime(2030),
                                            onDateTimeChanged: (date) {
                                              dateinstringFrom =
                                                  '${date.day}/${date.month}/${date.year}';
                                            },
                                            mode: CupertinoDatePickerMode.date,
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
                          });
                        },
                        child: Container(
                          width: Constants.screenWidth(context) * 0.2,
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
                                          minimumDate: DateTime.now(),
                                          maximumDate: DateTime(2030),
                                          onDateTimeChanged: (date) {
                                            setState(() {
                                              dateinstringTo =
                                                  '${date.day}/${date.month}/${date.year}';
                                            });
                                          },
                                          mode: CupertinoDatePickerMode.date,
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
                ],
              ),
            ),
          ),
          NavBox(
              buttonText: applicationBloc.loading ? "Please wait..." : "Assign",
              onPress: () async {
                if (fence.name.toString() == "Select Fence") {
                  Constants.showSnackBar(
                      context, "Please select the fence.", false);
                  return;
                }
                if (dateinstringFrom == "From") {
                  Constants.showSnackBar(
                      context, "Please select \"From Date\".", false);
                  return;
                }
                if (dateinstringTo == "To") {
                  Constants.showSnackBar(
                      context, "Please select \"To Date\".", false);
                  return;
                }
                if (fromTime == "From -:-") {
                  Constants.showSnackBar(
                      context, "Please select \"From Time\".", false);
                  return;
                }
                if (toTime == "To -:-") {
                  Constants.showSnackBar(
                      context, "Please select \"To Time\".", false);
                  return;
                }
                await applicationBloc.assignFenceToOneEmployee(
                    context,
                    widget.employee.sId.toString(),
                    fence.sId.toString(),
                    dateinstringFrom,
                    dateinstringTo,
                    fromTime,
                    toTime);
              }),
        ],
      ),
    );
  }
}

class PickFence extends StatefulWidget {
  const PickFence({Key? key}) : super(key: key);

  @override
  _PickFenceState createState() => _PickFenceState();
}

class _PickFenceState extends State<PickFence> {
  List<FenceModel> fences = [];
  List<dynamic> data = [];
  @override
  initState() {
    super.initState();
    _getFences();
    setState(() {});
  }

  _getFences() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    data = [];
    await Future.delayed(const Duration(milliseconds: 500), () {});
    data = await applicationBloc.getFences();
    List<Points> points = [];
    fences = [];
    for (var item in data) {
      points = [];
      for (var item in item['points']) {
        points.add(Points(lat: item['lat'], lng: item['lng']));
      }
      fences.add(FenceModel(
          name: item['name'].toString(), points: points, sId: item['_id']));
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Fence',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              height: Constants.screenHeight(context) * 0.47,
              child: ListView.builder(
                  itemCount: fences.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          minLeadingWidth: 0,
                          onTap: () {
                            Navigator.pop(context, fences[index]);
                          },
                          title: Text(
                            fences[index].name.toString(),
                            style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
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
