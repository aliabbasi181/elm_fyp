import 'package:elm_fyp/Models/EmpoloyeeLocationModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:flutter/material.dart';
import 'package:elm_fyp/Views/widgets.dart';

class Log {
  String time;
  bool inFence;
  Log(this.time, this.inFence);
}

class EmployeeLocationsLog extends StatefulWidget {
  String name;
  EmployeeLocationModel employeeLocationModel;
  String assignedFence;
  EmployeeLocationsLog(
      {Key? key,
      required this.name,
      required this.employeeLocationModel,
      required this.assignedFence})
      : super(key: key);

  @override
  _EmployeeLocationsLogState createState() => _EmployeeLocationsLogState();
}

class _EmployeeLocationsLogState extends State<EmployeeLocationsLog> {
  List<Log> data = [];
  @override
  initState() {
    super.initState();
    print(widget.employeeLocationModel.date);
    data.add(Log("12:45", true));
    data.add(Log("12:50", true));
    data.add(Log("12:55", false));
    data.add(Log("1:00", true));
    data.add(Log("1:05", true));
    data.add(Log("1:10", true));
    data.add(Log("1:15", false));
    data.add(Log("1:20", false));
    data.add(Log("1:25", false));
    data.add(Log("1:30", false));
    data.add(Log("1:35", false));
    data.add(Log("1:40", true));
    data.add(Log("1:45", true));
    data.add(Log("1:50", true));
    data.add(Log("1:55", true));
    data.add(Log("2:00", true));
    data.add(Log("2:05", false));
    data.add(Log("2:10", false));
    data.add(Log("2:15", false));
    data.add(Log("2:20", false));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                            "${widget.name} (Log)",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: FontStyle(20, Colors.black, FontWeight.bold),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Assigned Fence: ${widget.assignedFence}",
                    style: FontStyle(14, Colors.black, FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Date: ${widget.employeeLocationModel.date}",
                    style: FontStyle(14, Colors.black, FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 110,
                          child: Text("Time",
                              textAlign: TextAlign.center,
                              style:
                                  FontStyle(18, Colors.white, FontWeight.bold)),
                        ),
                        Container(
                          width: 120,
                          child: Text("Status",
                              style:
                                  FontStyle(18, Colors.white, FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black54, blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    height: Constants.screenHeight(context) * 0.68,
                    child: ListView.builder(
                      itemCount: widget.employeeLocationModel.locations!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Constants.primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                                widget.employeeLocationModel.locations![index]
                                    .time
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: FontStyle(
                                    16, Colors.white, FontWeight.w500)),
                          ),
                          title: Text(
                              widget.employeeLocationModel.locations![index]
                                          .inFence
                                          .toString() ==
                                      "true"
                                  ? "In the fence"
                                  : "Out of fence",
                              style: FontStyle(
                                  16,
                                  widget.employeeLocationModel.locations![index]
                                              .inFence
                                              .toString() ==
                                          "true"
                                      ? Constants.primaryColor
                                      : Colors.red,
                                  FontWeight.w500)),
                        );
                      },
                    ),
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
