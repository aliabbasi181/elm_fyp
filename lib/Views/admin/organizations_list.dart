import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:elm_fyp/Views/admin/add_organization.dart';
import 'package:elm_fyp/Views/admin/organization_profile_detail.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

List<OrganizationModel> organizations = [];

class OrganizationsList extends StatefulWidget {
  const OrganizationsList({Key? key}) : super(key: key);

  @override
  _OrganizationsListState createState() => _OrganizationsListState();
}

class _OrganizationsListState extends State<OrganizationsList> {
  List<dynamic> data = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<OrganizationModel> searchResults = [];

  @override
  initState() {
    _getOrganizations();
    super.initState();
  }

  _getOrganizations() async {
    organizations = [];
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 500), () {});
    data = await applicationBloc.getOrganizations();
    for (var item in data) {
      organizations.add(OrganizationModel(
          sId: item['_id'],
          name: item['name'],
          email: item['email'],
          address: item['address'],
          role: item['role'],
          isConfirmed: item['isConfirmed'],
          createdAt:
              item['createdAt'].toString().split(':').first.split('T').first,
          phone: item['phone']));
    }
    organizations = List.from(organizations.reversed);
  }

  void _onRefresh() async {
    await _getOrganizations();
    _refreshController.refreshCompleted();
  }

  Future<bool> _onDelete(String id) async {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    if (await applicationBloc.deleteOrganization(id)) {
      Constants.showSnackBar(
          context, "Organization successfully deleted...", true);
      //await Future.delayed(const Duration(milliseconds: 500), () {});
      return true;
    } else {
      Constants.showSnackBar(context, "Error deleting organization...", false);
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
                            Text("Admin: Employee Location Management",
                                textAlign: TextAlign.start,
                                style: FontStyle(
                                    14, Colors.white, FontWeight.w400)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "All Organizations",
                                  style: FontStyle(
                                      30, Colors.white, FontWeight.bold),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.filter_alt,
                                        color: Constants.primaryColor,
                                        size: 20,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    )
                                  ],
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
                                          for (var item in organizations) {
                                            if (item.name!
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
                      visible:
                          organizations.length == 0 && !applicationBloc.loading,
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
                        visible:
                            organizations.length > 0 && searchResults.isEmpty,
                        child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: SmartRefresher(
                            onRefresh: () => _onRefresh(),
                            controller: _refreshController,
                            child: ListView.builder(
                              itemCount: organizations.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrganizationProfileDetail(
                                                    organization:
                                                        organizations[index])));
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
                                                    organizations[index]
                                                        .name
                                                        .toString(),
                                                    style: FontStyle(
                                                        20,
                                                        Constants.primaryColor,
                                                        FontWeight.w500)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        organizations[index]
                                                            .email
                                                            .toString(),
                                                        style: FontStyle(
                                                            12,
                                                            Colors.black38,
                                                            FontWeight.w400)),
                                                    Container(
                                                      child: Text(
                                                          organizations[index]
                                                                      .isConfirmed
                                                                      .toString() ==
                                                                  "true"
                                                              ? "Active"
                                                              : "Unactive",
                                                          style: FontStyle(
                                                              12,
                                                              organizations[index]
                                                                          .isConfirmed
                                                                          .toString() ==
                                                                      "true"
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              FontWeight.w400)),
                                                    ),
                                                  ],
                                                ),
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
                                                                var data =
                                                                    await applicationBloc
                                                                        .organizationUpdateStatus(
                                                                  organizations[
                                                                          index]
                                                                      .sId
                                                                      .toString(),
                                                                  organizations[index]
                                                                              .isConfirmed
                                                                              .toString() ==
                                                                          "true"
                                                                      ? false
                                                                      : true,
                                                                );
                                                                if (data.name !=
                                                                    null) {
                                                                  setState(() {
                                                                    organizations[
                                                                            index] =
                                                                        data;
                                                                  });
                                                                }
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  organizations[index]
                                                                              .isConfirmed
                                                                              .toString() ==
                                                                          "true"
                                                                      ? "Unactive"
                                                                      : "Active",
                                                                  style: FontStyle(
                                                                      20,
                                                                      organizations[index].isConfirmed.toString() ==
                                                                              "true"
                                                                          ? Colors
                                                                              .red
                                                                          : Constants
                                                                              .primaryColor,
                                                                      FontWeight
                                                                          .w400)),
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
                        visible: organizations.length > 0 &&
                            searchResults.isNotEmpty,
                        child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OrganizationProfileDetail(
                                                  organization:
                                                      searchResults[index])));
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
                                                  searchResults[index]
                                                      .name
                                                      .toString(),
                                                  style: FontStyle(
                                                      20,
                                                      Constants.primaryColor,
                                                      FontWeight.w500)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      searchResults[index]
                                                          .email
                                                          .toString(),
                                                      style: FontStyle(
                                                          12,
                                                          Colors.black38,
                                                          FontWeight.w400)),
                                                  Container(
                                                    child: Text(
                                                        searchResults[index]
                                                                    .isConfirmed
                                                                    .toString() ==
                                                                "true"
                                                            ? "Active"
                                                            : "Unactive",
                                                        style: FontStyle(
                                                            12,
                                                            searchResults[index]
                                                                        .isConfirmed
                                                                        .toString() ==
                                                                    "true"
                                                                ? Colors.green
                                                                : Colors.red,
                                                            FontWeight.w400)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                          InkWell(
                                            onTap: () async {
                                              await showCupertinoModalPopup(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  context: context,
                                                  builder:
                                                      (context) =>
                                                          CupertinoActionSheet(
                                                            actions: [
                                                              CupertinoActionSheetAction(
                                                                onPressed:
                                                                    () async {
                                                                  var data =
                                                                      await applicationBloc
                                                                          .organizationUpdateStatus(
                                                                    searchResults[
                                                                            index]
                                                                        .sId
                                                                        .toString(),
                                                                    searchResults[index].isConfirmed.toString() ==
                                                                            "true"
                                                                        ? false
                                                                        : true,
                                                                  );
                                                                  if (data.name !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      searchResults[
                                                                              index] =
                                                                          data;
                                                                      organizations[organizations.indexWhere((element) =>
                                                                          element
                                                                              .sId ==
                                                                          data.sId)] = data;
                                                                    });
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    searchResults[index].isConfirmed.toString() ==
                                                                            "true"
                                                                        ? "Unactive"
                                                                        : "Active",
                                                                    style: FontStyle(
                                                                        20,
                                                                        searchResults[index].isConfirmed.toString() ==
                                                                                "true"
                                                                            ? Colors
                                                                                .red
                                                                            : Constants
                                                                                .primaryColor,
                                                                        FontWeight
                                                                            .w400)),
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
                buttonText: "Add Organization",
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddOrganization(
                                user: "admin",
                              )));
                },
              ),
            ],
          )),
    );
  }
}

class MyListTileOrg extends StatefulWidget {
  VoidCallback onPress;
  OrganizationModel organization;
  MyListTileOrg({
    Key? key,
    required this.organization,
    required this.onPress,
  }) : super(key: key);

  @override
  _MyListTileOrgState createState() => _MyListTileOrgState();
}

class _MyListTileOrgState extends State<MyListTileOrg> {
  @override
  void initState() {
    print(widget.organization.sId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
        margin: const EdgeInsets.only(top: 10, left: 30, right: 30),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(stops: const [
            0.015,
            0.01
          ], colors: [
            Constants.primaryColor,
            const Color.fromRGBO(255, 255, 255, 0.7)
          ]),
        ),
        child: ListTile(
            // subtitle: Text(
            //   widget.employees,
            //   style:
            //       TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
            // ),
            title: Text(widget.organization.name.toString(),
                style: FontStyle(20, Constants.primaryColor, FontWeight.w500)),
            trailing: InkWell(
              onTap: () {
                showCupertinoModalPopup(
                    barrierColor: Colors.black.withOpacity(0.5),
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                          actions: [
                            CupertinoButton(
                                color: Colors.red,
                                child: Text(
                                  "Delete",
                                  style: FontStyle(
                                      24, Colors.white, FontWeight.w400),
                                ),
                                onPressed: () {
                                  setState(() {
                                    organizations.removeWhere((element) =>
                                        element.sId == widget.organization.sId);
                                  });
                                  Navigator.pop(context);
                                })
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ));
              },
              child: const Icon(
                CupertinoIcons.delete,
                size: 20,
                color: Colors.red,
              ),
            )),
      ),
    );
  }
}
