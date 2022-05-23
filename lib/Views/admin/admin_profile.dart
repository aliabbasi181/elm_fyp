import 'package:dotted_border/dotted_border.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/employee/employee_profile.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
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
                                        Text("ELMS on Secure Map",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: FontStyle(24, Colors.white,
                                                FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("admin@elms.com",
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
                                        body: "051-540403423",
                                      ),
                                      UserDetailRow(
                                        heading: "Role",
                                        body: "Super admin",
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
            ],
          )),
    );
  }
}
