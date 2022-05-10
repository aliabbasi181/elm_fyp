import 'dart:async';

import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/organization/update_fence.dart';
import 'package:elm_fyp/Views/widgets.dart';
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
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
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
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    var today = DateTime.now();
    var data = await applicationBloc.getEmployeesLastLocation();
    for (var item in data) {
      if (item['fenceId'].toString() == widget.fence.sId.toString()) {
        var emp =
            await applicationBloc.getEmployeeDetailById(item['employeeId']);
        allMarkers.add(Marker(
            width: 150,
            height: 50,
            point: LatLng(double.parse(item['lat'].toString()),
                double.parse(item['lng'].toString())),
            builder: (context) {
              return Column(
                children: [
                  Container(
                    color: Constants.primaryColor,
                    child: Text(
                      emp['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(Icons.circle),
                ],
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
                    height: Constants.screenWidth(context) * 0.030,
                  ),
                  Container(
                    height: Constants.screenHeight(context) * 0.70,
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
                        center: center,
                        zoom: _zoomValue,
                        onTap: (position, latlng) {
                          print("${latlng.latitude},${latlng.longitude}");
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
                  Row(
                    children: [
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
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54, blurRadius: 5)
                                ],
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              CupertinoIcons.minus,
                              size: 16,
                            )),
                      ),
                      Expanded(
                        child: Slider(
                            activeColor: Constants.primaryColor,
                            min: 5,
                            max: 15.4,
                            label: "Zoom Level",
                            value: _zoomValue,
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _zoomValue = value;
                                mapController.move(center!, value);
                              });
                            }),
                      ),
                      InkWell(
                        onTap: () {
                          var temp = _zoomValue;
                          if (temp++ < 15.4 || temp++ == 15.4) {
                            setState(() {
                              _zoomValue++;
                              mapController.move(center!, _zoomValue);
                            });
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54, blurRadius: 5)
                                ],
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              CupertinoIcons.plus,
                              size: 16,
                            )),
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
