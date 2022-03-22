import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
  @override
  initState() {
    super.initState();
    for (var item in widget.fence.points!) {
      latlnglist.add(LatLng(double.parse(item.lat.toString()),
          double.parse(item.lng.toString())));
    }
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
                      Text(
                        widget.fence.name.toString(),
                        style: FontStyle(20, Colors.black, FontWeight.bold),
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
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
                      ))
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
                        center: latlnglist.first,
                        zoom: 12,
                        onTap: (position, latlng) {
                          print("${latlng.latitude},${latlng.longitude}");
                          setState(() {
                            marker.add(Marker(
                                point: latlng,
                                builder: (context) {
                                  return const Icon(Icons.location_on);
                                }));
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
                        MarkerLayerOptions(markers: marker)
                      ],
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                    text: "50 Employees",
                    style: FontStyle(18, Colors.black87, FontWeight.w500),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
