import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:elm_fyp/Views/admin/add_organization.dart';
import 'package:elm_fyp/Views/admin/admin_nav.dart';
import 'package:elm_fyp/local_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import '../constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController ip = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        height: Constants.screenHeight(context),
        width: Constants.screenWidth(context),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background_image.jpg"),
                fit: BoxFit.fill)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Constants.screenHeight(context) * 0.1,
                ),
                Text(
                  "Let's sign you in.",
                  style: FontStyle(40, Colors.black, FontWeight.bold),
                ),
                Text("Wellcome back",
                    style: FontStyle(25, Colors.black, FontWeight.w300)),
                Text("You have been missed!",
                    style: FontStyle(25, Colors.black, FontWeight.w300)),
                SizedBox(
                  height: Constants.screenWidth(context) * 0.2,
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      height: Constants.screenHeight(context) * 0.35,
                      width: Constants.screenWidth(context),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(0),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InputField(
                              hint: "Enter Email",
                              icon: Ionicons.person_circle,
                              controller: email),
                          InputPasswordField(
                              hint: "Enter Password",
                              icon: Ionicons.key,
                              controller: password),
                          InkWell(
                            onTap: () {},
                            child: InkWell(
                              onTap: () async {
                                if (email.text == "admin@elms.com" &&
                                    password.text == "admin") {
                                  LocalStorage.setCredentials(
                                      "admin", "admin", "0");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminNav()),
                                      (route) => false);
                                } else {
                                  // email.text = "admin@mtbc.com";
                                  // password.text = "admin1234";
                                  email.text = "abubakrbanti@gmail.com";
                                  password.text = "admin1234";
                                  applicationBloc.login(
                                      context, email.text, password.text);
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                width: Constants.screenWidth(context) * 0.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                        visible: applicationBloc.loading,
                                        child: CupertinoActivityIndicator()),
                                    Text(
                                        applicationBloc.loading
                                            ? "Please wait..."
                                            : "Login",
                                        textAlign: TextAlign.center,
                                        style: FontStyle(24, Colors.black54,
                                            FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOrganization(
                                      user: "organization",
                                    )));
                        // ip.text = "a.tile.openstreetmap.org";
                        // showModalBottomSheet<void>(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return Container(
                        //       height: 300,
                        //       color: Colors.white,
                        //       child: Center(
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: <Widget>[
                        //             InputField(
                        //                 hint: "IP of map",
                        //                 icon: Icons.network_check_outlined,
                        //                 controller: ip),
                        //             ElevatedButton(
                        //               child: const Text('Connect'),
                        //               onPressed: () {
                        //                 if (ip.text.isNotEmpty) {
                        //                   Constants.setMapIP(
                        //                       ip.text.toString());
                        //                   Navigator.pop(context);
                        //                 }
                        //               },
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(100)),
                        child: const Text(
                          "Signup Organization",
                          style: TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
