import 'package:flutter/material.dart';
import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class AssignFenceMultipleEmployees extends StatefulWidget {
  FenceModel fence;
  AssignFenceMultipleEmployees({Key? key, required this.fence})
      : super(key: key);

  @override
  _AssignFenceMultipleEmployeesState createState() =>
      _AssignFenceMultipleEmployeesState();
}

class Fence {
  String name;
  Fence(this.name);
}

class _AssignFenceMultipleEmployeesState
    extends State<AssignFenceMultipleEmployees> {
  List<LatLng> latlnglist = <LatLng>[];
  MapController mapController = MapController();
  List<LatLng> fenceList = [LatLng(33.5651, 73.0169)];
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  String dateinstringFrom = "From";
  String dateinstringTo = "To";
  String fromTime = "From -:-";
  String toTime = "To -:-";
  String selectEmployeesList = "Select Employees";
  List<EmployeeModel> selectedEmployees = [];
  LatLng? center;
  double _zoomValue = 14;
  @override
  initState() {
    super.initState();
    setState(() {});
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
                          widget.fence.name.toString(),
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
                    height: Constants.screenHeight(context) * 0.4,
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
                            height: Constants.screenHeight(context) * 0.4,
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
                                    latlnglist.add(latlng);
                                  });
                                },
                              ),
                              layers: [
                                TileLayerOptions(urlTemplate: Constants.mapURL),
                                PolygonLayerOptions(polygons: [
                                  Polygon(
                                      points: latlnglist,
                                      color: Colors.transparent,
                                      borderColor: Colors.black,
                                      borderStrokeWidth: 5)
                                ]),
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
                  InkWell(
                    onTap: () async {
                      try {
                        selectedEmployees = await showModalBottomSheet(
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
                                  child: PickEmployees(
                                    selectedEmployees: selectedEmployees,
                                  ),
                                ),
                              );
                            });
                        if (selectedEmployees.length > 0) {
                          selectEmployeesList =
                              "${selectedEmployees.length} employees selected.";
                        }
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
                            child: Text(selectEmployeesList,
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
                ],
              ),
            ),
          ),
          NavBox(
              buttonText: applicationBloc.loading ? "Please wait..." : "Assign",
              onPress: () async {
                if (selectedEmployees.length == 0) {
                  Constants.showSnackBar(
                      context, "No employee(s) selected", false);
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
                switch (await showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: const Text("CONFIRMATION ALERT!"),
                          content: Text(
                              "You want to assign fence (${widget.fence.name}) to ${selectedEmployees.length}?"),
                          actions: [
                            CupertinoDialogAction(
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop("No");
                                }),
                            CupertinoDialogAction(
                                child: const Text(
                                  "YES",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop("YES");
                                }),
                          ],
                        ))) {
                  case "YES":
                    print(true);
                    break;
                }
                // await applicationBloc.assignFenceToOneEmployee(
                //     context,
                //     widget.fence.sId.toString(),
                //     fence.sId.toString(),
                //     dateinstringFrom,
                //     dateinstringTo,
                //     fromTime,
                //     toTime);
              }),
        ],
      ),
    );
  }
}

class PickEmployees extends StatefulWidget {
  List<EmployeeModel> selectedEmployees;
  PickEmployees({Key? key, required this.selectedEmployees}) : super(key: key);

  @override
  _PickEmployeesState createState() => _PickEmployeesState();
}

class _PickEmployeesState extends State<PickEmployees> {
  List<EmployeeModel> employees = [];
  List<dynamic> data = [];
  List<bool> isCheck = [];
  @override
  initState() {
    super.initState();
    _getEmployees();
    setState(() {});
  }

  _getEmployees() async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 500), () {});
    data = await applicationBloc.getEmployees();
    employees = [];
    bool isMatched = false;
    for (var item in data) {
      if (widget.selectedEmployees.isNotEmpty) {
        isMatched = false;
        for (var employee in widget.selectedEmployees) {
          if (item['_id'] == employee.sId) {
            print(item['_id']);
            isCheck.add(true);
            isMatched = true;
            break;
          }
        }
        if (!isMatched) isCheck.add(false);
      } else {
        isCheck.add(false);
      }
      employees.add(EmployeeModel(
          sId: item['_id'],
          name: item['name'],
          email: item['email'],
          cnic: item['cnic'],
          role: item['role'],
          phone: item['phone']));
    }
    employees = List.from(employees.reversed);
    isCheck = List.from(isCheck.reversed);
    setState(() {});
  }

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
                  'Select Employees',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, widget.selectedEmployees);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 1.5)
                        ],
                        color: Constants.primaryColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      "Done",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyle(14, Colors.white, FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: Constants.screenHeight(context) * 0.45,
              child: ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isCheck[index] = !isCheck[index];
                          if (!isCheck[index]) {
                            widget.selectedEmployees.removeWhere((element) =>
                                element.sId == employees[index].sId);
                          } else {
                            widget.selectedEmployees.add(employees[index]);
                          }
                        });
                      },
                      child: Container(
                        width: Constants.screenWidth(context),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isCheck[index],
                                  onChanged: (value) {
                                    setState(() {
                                      isCheck[index] = value!;
                                    });
                                    if (!value!) {
                                      widget.selectedEmployees.removeWhere(
                                          (element) =>
                                              element.sId ==
                                              employees[index].sId);
                                    }
                                  },
                                ),
                                Text(employees[index].name.toString(),
                                    style: FontStyle(
                                        14, Colors.black, FontWeight.w400)),
                              ],
                            ),
                            const Divider(
                              color: Color(0XFFFeceef0),
                              thickness: 1,
                              height: 0,
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
