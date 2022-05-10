import 'package:dotted_border/dotted_border.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/employee/update_profile.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:elm_fyp/Views/organization/update_profile.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({Key? key}) : super(key: key);

  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              SingleChildScrollView(
                child: Container(
                  height: Constants.screenHeight(context),
                  width: Constants.screenWidth(context),
                  child: Column(
                    children: [
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          //height: Constants.screnHeight(context) * 0.52,
                          margin: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                          decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 20, // Shadow position
                                ),
                              ],
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/background_image.jpg"),
                                            fit: BoxFit.fill)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 0, 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(Constants.employee.name.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: FontStyle(24, Colors.white,
                                                FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            Constants.employee.email.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: FontStyle(16, Colors.white,
                                                FontWeight.w500)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DottedBorder(
                                  color: Colors.white,
                                  strokeWidth: 1.5,
                                  dashPattern: const [5, 5],
                                  strokeCap: StrokeCap.butt,
                                  borderType: BorderType.RRect,
                                  padding: const EdgeInsets.all(20),
                                  radius: const Radius.circular(30),
                                  child: Column(
                                    children: [
                                      UserDetailRow(
                                        heading: "Phone",
                                        body:
                                            Constants.employee.phone.toString(),
                                      ),
                                      UserDetailRow(
                                          heading: "Designation",
                                          body: Constants.employee.designation
                                              .toString()),
                                      UserDetailRow(
                                          heading: "CNIC",
                                          body: Constants.employee.cnic
                                              .toString()),
                                      UserDetailRow(
                                        heading: "Address",
                                        body: Constants.employee.designation
                                            .toString(),
                                      ),
                                      UserDetailRow(
                                        heading: "Role",
                                        body:
                                            Constants.employee.role.toString(),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          UserOptions(
                            text: "Logout",
                            icon: Icons.logout_rounded,
                            onPress: () async {
                              switch (await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                        title: const Text("LOGOUT ALERT!"),
                                        content: const Text(
                                            "Are you sure you want to logout from ELMS?"),
                                        actions: [
                                          CupertinoDialogAction(
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop("No");
                                              }),
                                          CupertinoDialogAction(
                                              child: const Text(
                                                "LOGOUT",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontFamily: "Montserrat",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop("Logout");
                                              }),
                                        ],
                                      ))) {
                                case "Logout":
                                  await LocalStorage.removeUser();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()),
                                      (route) => false);
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              NavBox(
                buttonText: "Update Profile",
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmployeeProfileUpdate()));
                },
              ),
            ],
          )),
    );
  }
}

class UserDetailRow extends StatelessWidget {
  String heading, body;
  UserDetailRow({Key? key, required this.heading, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              "$heading:",
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: Text(
            body,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70),
          ))
        ],
      ),
    );
  }
}

class UserOptions extends StatefulWidget {
  String text;
  VoidCallback onPress;
  IconData icon;
  UserOptions(
      {Key? key, required this.text, required this.icon, required this.onPress})
      : super(key: key);

  @override
  _UserOptionsState createState() => _UserOptionsState();
}

class _UserOptionsState extends State<UserOptions> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1.5)],
              color: const Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(10),
              border: widget.text == "Logout"
                  ? Border.all(color: Constants.primaryColor, width: 2)
                  : null),
          padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
          margin: const EdgeInsets.only(bottom: 5, left: 20, right: 20, top: 5),
          width: Constants.screenWidth(context),
          child: ListTile(
            leading: Icon(
              widget.icon,
              size: 22,
              color: Constants.primaryColor,
            ),
            title: Text(widget.text,
                style: TextStyle(
                    fontSize: 22,
                    color: Constants.primaryColor,
                    fontWeight:
                        widget.text == "Logout" ? FontWeight.bold : null)),
          )),
    );
  }
}
