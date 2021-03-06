import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../BLoc/application_bloc.dart';

class CreateFence extends StatefulWidget {
  const CreateFence({Key? key}) : super(key: key);

  @override
  _CreateFenceState createState() => _CreateFenceState();
}

class _CreateFenceState extends State<CreateFence> {
  TextEditingController name = TextEditingController();
  List<LatLng> latlnglist = <LatLng>[];
  List<LatLng> redolist = <LatLng>[];
  MapController mapController = MapController();
  double _zoomValue = 14;
  LatLng center = LatLng(33.5651, 73.0169);
  @override
  initState() {
    super.initState();
  }

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
                  Text("Add new fence",
                      textAlign: TextAlign.center,
                      style: FontStyle(26, Colors.black, FontWeight.bold)),
                  SizedBox(
                    height: Constants.screenWidth(context) * 0.010,
                  ),
                  InputField(
                      hint: "Fence Name (Required)",
                      icon: Icons.map_outlined,
                      controller: name),
                  SizedBox(
                    height: Constants.screenWidth(context) * 0.010,
                  ),
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
                                  print(
                                      "${latlng.latitude},${latlng.longitude}");
                                  setState(() {
                                    latlnglist.add(latlng);
                                  });
                                },
                              ),
                              layers: [
                                TileLayerOptions(
                                  urlTemplate: Constants.mapURL,
                                ),
                                PolylineLayerOptions(polylines: [
                                  Polyline(
                                      color: Colors.red,
                                      strokeWidth: 5,
                                      points: latlnglist)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (latlnglist.isNotEmpty) {
                              redolist.add(latlnglist.last);
                              latlnglist.removeLast();
                            }
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => latlnglist.isNotEmpty
                                    ? Constants.primaryColor
                                    : Colors.grey)),
                        icon: const Icon(
                          Icons.undo_rounded,
                          size: 20,
                        ),
                        label: Text(
                          "Undo",
                          style: FontStyle(16, Colors.white, FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (redolist.isNotEmpty) {
                            setState(() {
                              latlnglist.add(redolist.last);
                              redolist.removeLast();
                            });
                          }
                          setState(() {});
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => redolist.isNotEmpty
                                    ? Constants.primaryColor
                                    : Colors.grey)),
                        icon: const Icon(
                          Icons.redo_rounded,
                          size: 30,
                        ),
                        label: Text(
                          "Redo",
                          style: FontStyle(16, Colors.white, FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          NavBox(
            buttonText: applicationBloc.loading ? "Please wait..." : "Save",
            onPress: () async {
              if (name.text.isNotEmpty) {
                if (latlnglist.length > 2) {
                  setState(() {
                    latlnglist.add(latlnglist[0]);
                  });
                  if (await applicationBloc.createFence(
                      name.text, latlnglist)) {
                    Constants.showSnackBar(
                        context, "Fence created successfully...", true);
                    setState(() {
                      name.text = "";
                      latlnglist = [];
                      redolist = [];
                    });
                  } else {
                    Constants.showSnackBar(
                        context, "Error creating fence...", false);
                  }
                } else {
                  Constants.showSnackBar(
                      context, "Fence must have atleast 3 points", false);
                }
              } else {
                Constants.showSnackBar(context, "Name can not be empty", false);
              }
            },
          ),
        ],
      ),
    );
  }
}
