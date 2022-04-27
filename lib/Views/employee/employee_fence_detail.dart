import 'package:elm_fyp/Models/AssignedFenceModel.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EmployeeFenceDetail extends StatefulWidget {
  FenceModel fence;
  AssignedFenceModel assignedFenc;
  EmployeeFenceDetail(
      {Key? key, required this.fence, required this.assignedFenc})
      : super(key: key);

  @override
  _EmployeeFenceDetailState createState() => _EmployeeFenceDetailState();
}

class _EmployeeFenceDetailState extends State<EmployeeFenceDetail> {
  List<LatLng> latlnglist = <LatLng>[];
  List<LatLng> userPoints = <LatLng>[];
  MapController mapController = MapController();
  List<Marker> marker = [];
  double _zoomValue = 14;
  LatLng? center;
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
                    ],
                  ),
                  SizedBox(height: 10),
                  RichText(
                      text: TextSpan(
                          text: "Date: ",
                          style: FontStyle(15, Colors.black87, FontWeight.w400),
                          children: [
                        TextSpan(
                          text: widget.assignedFenc.dateFrom,
                          style: FontStyle(14, Colors.black87, FontWeight.w700),
                        ),
                        TextSpan(
                          text: "  - To -  ",
                          style: FontStyle(14, Colors.black87, FontWeight.w400),
                        ),
                        TextSpan(
                          text: widget.assignedFenc.dateTo,
                          style: FontStyle(14, Colors.black87, FontWeight.w700),
                        )
                      ])),
                  RichText(
                      text: TextSpan(
                          text: "Time: ",
                          style: FontStyle(15, Colors.black87, FontWeight.w400),
                          children: [
                        TextSpan(
                          text: widget.assignedFenc.startTime,
                          style: FontStyle(14, Colors.black87, FontWeight.w700),
                        ),
                        TextSpan(
                          text: "  - To -  ",
                          style: FontStyle(14, Colors.black87, FontWeight.w400),
                        ),
                        TextSpan(
                          text: widget.assignedFenc.endTime,
                          style: FontStyle(14, Colors.black87, FontWeight.w700),
                        )
                      ])),
                  SizedBox(height: 10),
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
                              color: Colors.red,
                              strokeWidth: 5,
                              points: latlnglist)
                        ]),
                        MarkerLayerOptions(markers: marker),
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
                            max: 16,
                            label: "Zoom Level",
                            value: _zoomValue,
                            onChanged: (value) {
                              setState(() {
                                _zoomValue = value;
                                mapController.move(center!, value);
                              });
                            }),
                      ),
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
