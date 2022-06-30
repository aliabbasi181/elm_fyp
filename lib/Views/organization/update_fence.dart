import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class UpdateFence extends StatefulWidget {
  FenceModel fence;
  UpdateFence({Key? key, required this.fence}) : super(key: key);

  @override
  _UpdateFenceState createState() => _UpdateFenceState();
}

class _UpdateFenceState extends State<UpdateFence> {
  TextEditingController name = TextEditingController();
  List<LatLng> latlnglist = <LatLng>[];
  List<LatLng> templatlnglist = <LatLng>[];
  List<LatLng> redolist = <LatLng>[];
  MapController mapController = MapController();
  LatLng? center;
  double _zoomValue = 14;
  List<Marker> markers = [];
  List<Marker> tempmarkers = [];
  LatLng changePosition = LatLng(0, 0);
  LatLng addToLeft = LatLng(0, 0);
  LatLng addToRight = LatLng(0, 0);
  String appbartext = "Update Fence";
  @override
  initState() {
    super.initState();
    name.text = widget.fence.name!;
    double lat = 0, lng = 0;
    for (var item in widget.fence.points!) {
      lat += double.parse(item.lat.toString());
      lng += double.parse(item.lng.toString());
      markers.add(Marker(
          point: LatLng(double.parse(item.lat.toString()),
              double.parse(item.lng.toString())),
          builder: (context) {
            return InkWell(
              onTap: () {
                print(item.lat.toString() + " | " + item.lng.toString());
                _showEditOption(LatLng(double.parse(item.lat.toString()),
                    double.parse(item.lng.toString())));
              },
              child: Icon(
                CupertinoIcons.location_solid,
                size: 30,
                color: Colors.red,
              ),
            );
          }));
      latlnglist.add(LatLng(double.parse(item.lat.toString()),
          double.parse(item.lng.toString())));
    }
    lat = lat / widget.fence.points!.length;
    lng = lng / widget.fence.points!.length;
    center = LatLng(lat, lng);
  }

  _showEditOption(LatLng latLng) async {
    await Future.delayed(Duration(microseconds: 500));
    changePosition == LatLng(0, 0)
        ? addToLeft == LatLng(0, 0)
            ? addToRight == LatLng(0, 0)
                ? showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                          title:
                              Text("Select one option to edit selected point"),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () {
                                try {
                                  templatlnglist.clear();
                                  tempmarkers.clear();
                                  //templatlnglist.addAll(latlnglist);
                                  latlnglist.forEach((element) {
                                    templatlnglist.add(element);
                                  });
                                  //markers.addAll(tempmarkers);
                                  markers.forEach((element) {
                                    tempmarkers.add(element);
                                  });
                                  appbartext = "Change position";
                                  changePosition = latLng;
                                  addToLeft = LatLng(0, 0);
                                  addToRight = LatLng(0, 0);
                                  setState(() {});
                                  Navigator.pop(context);
                                } catch (ex) {}
                              },
                              child: const Text("Change position"),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                try {
                                  templatlnglist.clear();
                                  tempmarkers.clear();
                                  //templatlnglist.addAll(latlnglist);
                                  latlnglist.forEach((element) {
                                    templatlnglist.add(element);
                                  });
                                  //markers.addAll(tempmarkers);
                                  markers.forEach((element) {
                                    tempmarkers.add(element);
                                  });
                                  appbartext = "Add point to right";
                                  changePosition = LatLng(0, 0);
                                  addToRight = latLng;
                                  addToLeft = LatLng(0, 0);
                                  setState(() {});
                                  Navigator.pop(context);
                                } catch (ex) {}
                              },
                              child: const Text("Add point to right"),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                try {
                                  templatlnglist.clear();
                                  tempmarkers.clear();
                                  //templatlnglist.addAll(latlnglist);
                                  latlnglist.forEach((element) {
                                    templatlnglist.add(element);
                                  });
                                  markers.addAll(tempmarkers);
                                  markers.forEach((element) {
                                    tempmarkers.add(element);
                                  });
                                  appbartext = "Add point to left";
                                  changePosition = LatLng(0, 0);
                                  addToLeft = latLng;
                                  addToRight = LatLng(0, 0);
                                  setState(() {});
                                  Navigator.pop(context);
                                } catch (ex) {}
                              },
                              child: const Text("Add point to left"),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                try {
                                  setState(() {
                                    latlnglist.removeWhere(
                                        (element) => element == latLng);
                                    markers.removeWhere(
                                        (element) => element.point == latLng);
                                  });
                                  Navigator.pop(context);
                                } catch (ex) {}
                              },
                              child: const Text(
                                "Remove",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ))
                : null
            : null
        : null;
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
                          appbartext,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  InputField(
                      hint: "Fence Name (Required)",
                      icon: Icons.map_outlined,
                      controller: name),
                  SizedBox(height: 10),
                  Container(
                    height: Constants.screenHeight(context) * 0.65,
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
                            height: Constants.screenHeight(context) * 0.65,
                            width: Constants.screenWidth(context),
                            child: FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                center: center,
                                zoom: _zoomValue,
                                onTap: (position, latlng) {
                                  if (changePosition != LatLng(0, 0)) {
                                    int index = templatlnglist.indexWhere(
                                        (element) => element == changePosition);
                                    templatlnglist[index] = latlng;
                                    index = tempmarkers.indexWhere((element) =>
                                        element.point == changePosition);
                                    tempmarkers[index] = Marker(
                                        point: latlng,
                                        builder: (context) {
                                          return InkWell(
                                            onTap: () {
                                              print(latlng);
                                              _showEditOption(latlng);
                                            },
                                            child: Icon(
                                              CupertinoIcons.location_solid,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                          );
                                        });
                                    changePosition = latlng;
                                    setState(() {});
                                  }
                                  if (addToLeft != LatLng(0, 0)) {
                                    int index = templatlnglist.indexWhere(
                                        (element) => element == addToLeft);
                                    templatlnglist.insert((index + 1), latlng);
                                    index = tempmarkers.indexWhere((element) =>
                                        element.point == addToLeft);
                                    tempmarkers.insert(
                                        (index + 1),
                                        Marker(
                                            point: latlng,
                                            builder: (context) {
                                              return InkWell(
                                                onTap: () {
                                                  print(latlng);
                                                  _showEditOption(latlng);
                                                },
                                                child: Icon(
                                                  CupertinoIcons.location_solid,
                                                  size: 30,
                                                  color: Colors.red,
                                                ),
                                              );
                                            }));
                                    addToLeft = LatLng(0, 0);
                                    changePosition = latlng;
                                    setState(() {});
                                  }
                                  if (addToRight != LatLng(0, 0)) {
                                    int index = templatlnglist.indexWhere(
                                        (element) => element == addToRight);
                                    templatlnglist.insert((index), latlng);
                                    index = tempmarkers.indexWhere((element) =>
                                        element.point == addToRight);
                                    tempmarkers.insert(
                                        (index),
                                        Marker(
                                            point: latlng,
                                            builder: (context) {
                                              return InkWell(
                                                onTap: () {
                                                  print(latlng);
                                                  _showEditOption(latlng);
                                                },
                                                child: Icon(
                                                  CupertinoIcons.location_solid,
                                                  size: 30,
                                                  color: Colors.red,
                                                ),
                                              );
                                            }));
                                    addToRight = LatLng(0, 0);
                                    changePosition = latlng;
                                    setState(() {});
                                  }
                                },
                              ),
                              layers: [
                                TileLayerOptions(urlTemplate: Constants.mapURL),
                                PolylineLayerOptions(polylines: [
                                  Polyline(
                                      isDotted: true,
                                      color: Colors.black,
                                      strokeWidth: 5,
                                      points: changePosition == LatLng(0, 0)
                                          ? addToLeft == LatLng(0, 0)
                                              ? addToRight == LatLng(0, 0)
                                                  ? latlnglist
                                                  : templatlnglist
                                              : templatlnglist
                                          : templatlnglist)
                                ]),
                                MarkerLayerOptions(
                                    markers: changePosition == LatLng(0, 0)
                                        ? addToLeft == LatLng(0, 0)
                                            ? addToRight == LatLng(0, 0)
                                                ? markers
                                                : tempmarkers
                                            : tempmarkers
                                        : tempmarkers)
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
                        ),
                        Visibility(
                          visible: changePosition != LatLng(0, 0) ||
                              addToLeft != LatLng(0, 0) ||
                              addToRight != LatLng(0, 0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      changePosition =
                                          addToLeft = addToRight = LatLng(0, 0);
                                      appbartext = "Update Fence";
                                      print(latlnglist == templatlnglist);
                                      templatlnglist.clear();
                                      tempmarkers.clear();
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.red),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      changePosition =
                                          addToLeft = addToRight = LatLng(0, 0);
                                      appbartext = "Update Fence";
                                      //latlnglist = templatlnglist;
                                      latlnglist.clear();
                                      latlnglist.addAll(templatlnglist);
                                      markers.addAll(tempmarkers);
                                      //markers = tempmarkers;
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Constants.primaryColor),
                                      child: Text(
                                        "Save",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          NavBox(
            buttonText: "Update",
            onPress: () async {
              switch (await showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text("ALERT!"),
                        content: const Text(
                            "Are you sure you want to update this fence?"),
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
                                "UPDATE",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "Montserrat",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop("UPDATE");
                              }),
                        ],
                      ))) {
                case "UPDATE":
                  final applicationBloc =
                      Provider.of<ApplicationBloc>(context, listen: false);
                  if (await applicationBloc.updateFence(
                      name.text, latlnglist, widget.fence.sId)) {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                              title: const Text("Hurra!"),
                              content: const Text("Fence Updated"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text(
                                      "Close",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            ));
                  } else {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                              title: const Text("Alert!"),
                              content: const Text("Fence Updated Failed"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text(
                                      "Close",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            ));
                  }
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChangeMarkerPositionUpdateFence extends StatefulWidget {
  List<LatLng> latlng;
  LatLng toChange;
  ChangeMarkerPositionUpdateFence(
      {Key? key, required this.latlng, required this.toChange})
      : super(key: key);

  @override
  State<ChangeMarkerPositionUpdateFence> createState() =>
      _ChangeMarkerPositionUpdateFenceState();
}

class _ChangeMarkerPositionUpdateFenceState
    extends State<ChangeMarkerPositionUpdateFence> {
  MapController mapController = MapController();
  LatLng? center;
  double _zoomValue = 14;
  List<Marker> markers = [];
  List<LatLng> latlnglist = <LatLng>[];
  @override
  void initState() {
    latlnglist = widget.latlng;
    double lat = 0, lng = 0;
    for (var item in latlnglist) {
      lat += item.latitude;
      lng += item.longitude;
      markers.add(Marker(
          point: LatLng(item.latitude, item.longitude),
          builder: (context) {
            return InkWell(
              onTap: () {},
              child: Icon(
                CupertinoIcons.location_solid,
                size: 30,
                color: item == widget.toChange
                    ? Colors.red
                    : Constants.primaryColor,
              ),
            );
          }));
    }
    lat = lat / widget.latlng.length;
    lng = lng / widget.latlng.length;
    center = LatLng(lat, lng);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      width: Constants.screenWidth(context),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Change position of point",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel_outlined))
          ]),
          Container(
            height: Constants.screenHeight(context) * 0.65,
            width: Constants.screenWidth(context),
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(bottom: 15, top: 15),
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
                    height: Constants.screenHeight(context) * 0.65,
                    width: Constants.screenWidth(context),
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: center,
                        zoom: _zoomValue,
                        onTap: (position, latlng) {
                          print(latlng);
                          for (var i = 0; i < latlnglist.length; i++) {
                            if (latlnglist[i] == widget.toChange) {
                              latlnglist[i] = latlng;
                            }
                          }
                          markers.clear();
                          for (var item in latlnglist) {
                            markers.add(Marker(
                                point: LatLng(item.latitude, item.longitude),
                                builder: (context) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      CupertinoIcons.location_solid,
                                      size: 30,
                                      color: item == latlng
                                          ? Colors.red
                                          : Constants.primaryColor,
                                    ),
                                  );
                                }));
                          }
                          widget.toChange = latlng;
                          setState(() {});
                        },
                      ),
                      layers: [
                        TileLayerOptions(urlTemplate: Constants.mapURL),
                        PolylineLayerOptions(polylines: [
                          Polyline(
                              isDotted: true,
                              color: Colors.black,
                              strokeWidth: 5,
                              points: latlnglist)
                        ]),
                        MarkerLayerOptions(markers: markers)
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
          InkWell(
            onTap: () {},
            child: Container(
              width: Constants.screenWidth(context),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                "Done",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
