import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UpdateFence extends StatefulWidget {
  FenceModel fence;
  UpdateFence({Key? key, required this.fence}) : super(key: key);

  @override
  _UpdateFenceState createState() => _UpdateFenceState();
}

class _UpdateFenceState extends State<UpdateFence> {
  TextEditingController name = TextEditingController();
  List<LatLng> latlnglist = <LatLng>[];
  List<LatLng> redolist = <LatLng>[];
  MapController mapController = MapController();
  LatLng? center;
  double _zoomValue = 14;
  List<Marker> markers = [];
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
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              title: Text("Select one option to edit selected point"),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: const Text("Change position"),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: const Text("Add point to right"),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: const Text("Add point to left"),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      latlnglist.removeWhere((element) => element == latLng);
                      markers.removeWhere((element) => element.point == latLng);
                    });
                    Navigator.pop(context);
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
            ));
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
                      const Expanded(
                        child: Text(
                          "Update fence",
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
                                center: latlnglist.isNotEmpty
                                    ? latlnglist.first
                                    : redolist.first,
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

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton.icon(
                  //       onPressed: () {
                  //         setState(() {
                  //           if (latlnglist.isNotEmpty) {
                  //             redolist.add(latlnglist.last);
                  //             latlnglist.removeLast();
                  //           }
                  //         });
                  //       },
                  //       style: ButtonStyle(
                  //           backgroundColor: MaterialStateProperty.resolveWith(
                  //               (states) => latlnglist.isNotEmpty
                  //                   ? Constants.primaryColor
                  //                   : Colors.grey)),
                  //       icon: const Icon(
                  //         Icons.undo_rounded,
                  //         size: 30,
                  //       ),
                  //       label: const Text(
                  //         "Undo",
                  //         style: TextStyle(fontSize: 18),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     ElevatedButton.icon(
                  //       onPressed: () {
                  //         if (redolist.isNotEmpty) {
                  //           setState(() {
                  //             latlnglist.add(redolist.last);
                  //             redolist.removeLast();
                  //           });
                  //         }
                  //         setState(() {});
                  //       },
                  //       style: ButtonStyle(
                  //           backgroundColor: MaterialStateProperty.resolveWith(
                  //               (states) => redolist.isNotEmpty
                  //                   ? Constants.primaryColor
                  //                   : Colors.grey)),
                  //       icon: const Icon(
                  //         Icons.redo_rounded,
                  //         size: 30,
                  //       ),
                  //       label: const Text(
                  //         "Redo",
                  //         style: TextStyle(fontSize: 18),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          NavBox(
            buttonText: "Update",
            onPress: () async {
              // if (name.text.isNotEmpty) {
              //   if (latlnglist.length > 2) {
              //     if (latlnglist.first != latlnglist.last) {
              //       latlnglist.add(latlnglist[0]);
              //     }
              //     setState(() {});
              //     //await Future.delayed(const Duration(seconds: 2));
              //     PostService post = PostService();
              //     widget.fence.name = name.text;
              //     List<Points> pointsP = [];
              //     for (var item in latlnglist) {
              //       pointsP.add(Points(
              //           lat: item.latitude.toString(),
              //           lng: item.longitude.toString()));
              //     }
              //     print(pointsP.length);
              //     widget.fence.points = pointsP;
              //     await post.updatePolygon(widget.fence);
              //     showtoast("Fence Updated Successfuly", "", 200, context);
              //     Constants.polygons.add(Polygon(
              //         borderColor: Colors.red,
              //         borderStrokeWidth: 5,
              //         color: Colors.black12,
              //         points: latlnglist));
              //     setState(() {});
              //   } else {
              //     showtoast(
              //         "Fence must have at least 3 points", "", 600, context);
              //   }
              // } else {
              //   showtoast("Name can not be empty", "", 700, context);
              // }
              //sleep(const Duration(seconds: 5));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const Dashboard_Admin()));
            },
          ),
        ],
      ),
    );
  }
}
