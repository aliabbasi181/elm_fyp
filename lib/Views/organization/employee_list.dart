import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/organization/add_employee.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

List<EmployeeModel> employees = [];

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  _OrganizationsListState createState() => _OrganizationsListState();
}

class _OrganizationsListState extends State<EmployeeList> {
  List<dynamic> data = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<EmployeeModel> searchResults = [];

  @override
  initState() {
    _getEmployees();
    super.initState();
  }

  _getEmployees() async {
    employees = [];
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 500), () {});
    data = await applicationBloc.getEmployees();
    for (var item in data) {
      employees.add(EmployeeModel(
          sId: item['_id'],
          name: item['name'],
          email: item['email'],
          cnic: item['cnic'],
          role: item['role'],
          phone: item['phone']));
    }
    employees = List.from(employees.reversed);
  }

  void _onRefresh() async {
    await _getEmployees();
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
                                  "All Employees",
                                  style: FontStyle(
                                      30, Colors.white, FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.people_outline,
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
                                          18, Colors.black54, FontWeight.w400),
                                      decoration: InputDecoration(
                                          hintText: "Search...",
                                          hintStyle: FontStyle(18,
                                              Colors.black26, FontWeight.w400),
                                          border: InputBorder.none),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.isEmpty) {
                                            searchResults = [];
                                            return;
                                          }
                                          searchResults = [];
                                          for (var item in employees) {
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
                                  borderRadius: BorderRadius.circular(15)),
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
                          employees.length == 0 && !applicationBloc.loading,
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
                        visible: employees.length > 0 && searchResults.isEmpty,
                        child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: SmartRefresher(
                            onRefresh: () => _onRefresh(),
                            controller: _refreshController,
                            child: ListView.builder(
                              itemCount: employees.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 10, top: 5, bottom: 5),
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 30, right: 30),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
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
                                        subtitle: Text(
                                            employees[index].email.toString(),
                                            style: FontStyle(12, Colors.black38,
                                                FontWeight.w400)),
                                        title: Text(
                                            employees[index].name.toString(),
                                            style: FontStyle(
                                                20,
                                                Constants.primaryColor,
                                                FontWeight.w500)),
                                        trailing: InkWell(
                                          onTap: () async {
                                            await showCupertinoModalPopup(
                                                barrierColor: Colors.black
                                                    .withOpacity(0.5),
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoActionSheet(
                                                      actions: [
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            setState(() {
                                                              employees.removeWhere(
                                                                  (element) =>
                                                                      element
                                                                          .sId ==
                                                                      employees[
                                                                              index]
                                                                          .sId);
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            // if (await _onDelete(
                                                            //     employees[index]
                                                            //         .sId
                                                            //         .toString())) {

                                                            // }
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
                                        )),
                                  ),
                                );
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible:
                            employees.length > 0 && searchResults.isNotEmpty,
                        child: Container(
                          height: Constants.screenHeight(context) * 0.59,
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10, top: 5, bottom: 5),
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 30, right: 30),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
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
                                      subtitle: Text(
                                          employees[index].email.toString(),
                                          style: FontStyle(12, Colors.black38,
                                              FontWeight.w400)),
                                      title: Text(
                                          searchResults[index].name.toString(),
                                          style: FontStyle(
                                              20,
                                              Constants.primaryColor,
                                              FontWeight.w500)),
                                      trailing: InkWell(
                                        onTap: () async {
                                          await showCupertinoModalPopup(
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
                                              context: context,
                                              builder: (context) =>
                                                  CupertinoActionSheet(
                                                    actions: [
                                                      CupertinoActionSheetAction(
                                                        onPressed: () async {
                                                          setState(() {
                                                            searchResults.removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .sId ==
                                                                    searchResults[
                                                                            index]
                                                                        .sId);
                                                            employees.removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .sId ==
                                                                    employees[
                                                                            index]
                                                                        .sId);
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          // if (await _onDelete(
                                                          //     searchResults[
                                                          //             index]
                                                          //         .sId
                                                          //         .toString())) {

                                                          // }
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: FontStyle(
                                                              18,
                                                              Colors.red,
                                                              FontWeight.w400),
                                                        ),
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {},
                                                        child: Text(
                                                          "Edit",
                                                          style: FontStyle(
                                                              18,
                                                              Colors.black,
                                                              FontWeight.w400),
                                                        ),
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        onPressed: () {},
                                                        child: Text(
                                                          "Assign Fence",
                                                          style: FontStyle(
                                                              18,
                                                              Colors.black,
                                                              FontWeight.w400),
                                                        ),
                                                      ),
                                                    ],
                                                    cancelButton:
                                                        CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                  ));
                                        },
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 24,
                                          color: Colors.black87,
                                        ),
                                      )),
                                ),
                              );
                            },
                          ),
                        )),
                  ],
                ),
              ),
              NavBox(
                buttonText: "Add Employee",
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddEmployee()));
                },
              ),
            ],
          )),
    );
  }
}


// await showCupertinoModalPopup(
//                                                 barrierColor: Colors.black
//                                                     .withOpacity(0.5),
//                                                 context: context,
//                                                 builder: (context) =>
//                                                     CupertinoActionSheet(
//                                                       actions: [
//                                                         CupertinoButton(
//                                                             color: Colors.red,
//                                                             child: Text(
//                                                               "Delete",
//                                                               style: FontStyle(
//                                                                   24,
//                                                                   Colors.white,
//                                                                   FontWeight
//                                                                       .w400),
//                                                             ),
//                                                             onPressed:
//                                                                 () async {
//                                                               Navigator.pop(
//                                                                   context);
//                                                               if (await _onDelete(
//                                                                   employees[
//                                                                           index]
//                                                                       .sId
//                                                                       .toString())) {
//                                                                 setState(() {
//                                                                   employees.removeWhere((element) =>
//                                                                       element
//                                                                           .sId ==
//                                                                       employees[
//                                                                               index]
//                                                                           .sId);
//                                                                 });
//                                                               }
//                                                             })
//                                                       ],
//                                                       cancelButton:
//                                                           CupertinoActionSheetAction(
//                                                         onPressed: () {
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         child: const Text(
//                                                             "Cancel"),
//                                                       ),
//                                                     ));


