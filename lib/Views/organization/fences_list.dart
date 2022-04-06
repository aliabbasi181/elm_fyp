import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/FenceModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/organization/assign_fence_multiple_employees.dart';
import 'package:elm_fyp/Views/organization/create_fence.dart';
import 'package:elm_fyp/Views/organization/fence_details.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

List<FenceModel> fences = [];

class FencesList extends StatefulWidget {
  const FencesList({Key? key}) : super(key: key);

  @override
  _OrganizationsListState createState() => _OrganizationsListState();
}

class _OrganizationsListState extends State<FencesList> {
  List<dynamic> data = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<FenceModel> searchResults = [];

  @override
  initState() {
    _getFences();
    super.initState();
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
      fences.add(FenceModel(name: item['name'], points: points));
    }
    setState(() {});
  }

  void _onRefresh() async {
    await _getFences();
    _refreshController.refreshCompleted();
  }

  Future<bool> _onDelete(String id) async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    if (await applicationBloc.deleteOrganization(id)) {
      Constants.showSnackBar(context, "Employee successfully deleted...", true);
      //await Future.delayed(const Duration(milliseconds: 500), () {});
      return true;
    } else {
      Constants.showSnackBar(context, "Error deleting employee...", false);
      //await Future.delayed(const Duration(milliseconds: 500), () {});
      return false;
    }
  }

  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xFFe6f5fd),
              Color(0xFFfde5eb),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: Constants.screenHeight(context),
                width: Constants.screenWidth(context),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      height: Constants.screenHeight(context) * 0.24,
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20, // Shadow position
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Org: Employee Location Management",
                                textAlign: TextAlign.start,
                                style: FontStyle(
                                    14, Colors.white, FontWeight.w400)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "All Fences",
                                  style: FontStyle(
                                      30, Colors.white, FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.map_outlined,
                                    color: Constants.primaryColor,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100)),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: Constants.screenWidth(context) * 0.65,
                              padding: const EdgeInsets.fromLTRB(20, 1, 10, 1),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      cursorColor: Constants.primaryColor,
                                      style: FontStyle(
                                          16, Colors.black54, FontWeight.w400),
                                      decoration: InputDecoration(
                                          hintText: "Search...",
                                          hintStyle: FontStyle(16,
                                              Colors.black26, FontWeight.w400),
                                          border: InputBorder.none),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.isEmpty) {
                                            searchResults = [];
                                            return;
                                          }
                                          searchResults = [];
                                          for (var item in fences) {
                                            if (item.name!
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    value.toLowerCase())) {
                                              searchResults.add(item);
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Icon(
                                    CupertinoIcons.search,
                                    color: Constants.primaryColor,
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: applicationBloc.loading,
                      child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: Center(
                              child: CupertinoActivityIndicator(
                            radius: 15,
                          ))),
                    ),
                    Visibility(
                      visible: fences.length == 0 && !applicationBloc.loading,
                      child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: Center(
                            child: Text("No data found",
                                textAlign: TextAlign.start,
                                style: FontStyle(
                                    14, Colors.black, FontWeight.w400)),
                          )),
                    ),
                    Visibility(
                        visible: fences.length > 0 && searchResults.isEmpty,
                        child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: SmartRefresher(
                            onRefresh: () => _onRefresh(),
                            controller: _refreshController,
                            child: ListView.builder(
                              itemCount: fences.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FenceDetail(
                                                fence: fences[index])));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                        top: 15,
                                        bottom: 15),
                                    margin: const EdgeInsets.only(
                                        top: 12, left: 30, right: 30),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 1.5)
                                      ],
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(stops: const [
                                        0.015,
                                        0.01
                                      ], colors: [
                                        Constants.primaryColor,
                                        const Color.fromRGBO(255, 255, 255, 1)
                                      ]),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    fences[index]
                                                        .name
                                                        .toString(),
                                                    style: FontStyle(
                                                        20,
                                                        Constants.primaryColor,
                                                        FontWeight.w500)),
                                              ],
                                            )),
                                            InkWell(
                                              onTap: () async {
                                                await showCupertinoModalPopup(
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    context: context,
                                                    builder: (context) =>
                                                        CupertinoActionSheet(
                                                          actions: [
                                                            CupertinoActionSheetAction(
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  fences.removeWhere((element) =>
                                                                      element
                                                                          .sId ==
                                                                      fences[index]
                                                                          .sId);
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Delete",
                                                                style: FontStyle(
                                                                    18,
                                                                    Colors.red,
                                                                    FontWeight
                                                                        .w400),
                                                              ),
                                                            ),
                                                            CupertinoActionSheetAction(
                                                              onPressed: () {},
                                                              child: Text(
                                                                "Edit",
                                                                style: FontStyle(
                                                                    18,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w400),
                                                              ),
                                                            ),
                                                            CupertinoActionSheetAction(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AssignFenceMultipleEmployees(fence: fences[index])));
                                                              },
                                                              child: Text(
                                                                "Assign Fence",
                                                                style: FontStyle(
                                                                    18,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w400),
                                                              ),
                                                            ),
                                                          ],
                                                          cancelButton:
                                                              CupertinoActionSheetAction(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Cancel"),
                                                          ),
                                                        ));
                                              },
                                              child: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 24,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: fences.length > 0 && searchResults.isNotEmpty,
                        child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FenceDetail(
                                              fence: fences[index])));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10, top: 15, bottom: 15),
                                  margin: const EdgeInsets.only(
                                      top: 12, left: 30, right: 30),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black, blurRadius: 1.5)
                                    ],
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(stops: const [
                                      0.015,
                                      0.01
                                    ], colors: [
                                      Constants.primaryColor,
                                      const Color.fromRGBO(255, 255, 255, 1)
                                    ]),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  fences[index].name.toString(),
                                                  style: FontStyle(
                                                      20,
                                                      Constants.primaryColor,
                                                      FontWeight.w500)),
                                            ],
                                          )),
                                          InkWell(
                                            onTap: () async {
                                              await showCupertinoModalPopup(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  context: context,
                                                  builder: (context) =>
                                                      CupertinoActionSheet(
                                                        actions: [
                                                          CupertinoActionSheetAction(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                searchResults.removeWhere((element) =>
                                                                    element
                                                                        .sId ==
                                                                    searchResults[
                                                                            index]
                                                                        .sId);
                                                                fences.removeWhere(
                                                                    (element) =>
                                                                        element
                                                                            .sId ==
                                                                        fences[index]
                                                                            .sId);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Delete",
                                                              style: FontStyle(
                                                                  18,
                                                                  Colors.red,
                                                                  FontWeight
                                                                      .w400),
                                                            ),
                                                          ),
                                                          CupertinoActionSheetAction(
                                                            onPressed: () {},
                                                            child: Text(
                                                              "Edit",
                                                              style: FontStyle(
                                                                  18,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .w400),
                                                            ),
                                                          ),
                                                          CupertinoActionSheetAction(
                                                            onPressed: () {},
                                                            child: Text(
                                                              "Assign Fence",
                                                              style: FontStyle(
                                                                  18,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .w400),
                                                            ),
                                                          ),
                                                        ],
                                                        cancelButton:
                                                            CupertinoActionSheetAction(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Cancel"),
                                                        ),
                                                      ));
                                            },
                                            child: const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 24,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                  ],
                ),
              ),
              NavBox(
                buttonText: "Add new fence",
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateFence()));
                },
              ),
            ],
          )),
    );
  }
}
