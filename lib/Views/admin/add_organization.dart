import 'package:another_flushbar/flushbar.dart';
import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class AddOrganization extends StatefulWidget {
  String? user = "admin";
  AddOrganization({Key? key, this.user}) : super(key: key);

  @override
  _AddOrganizationState createState() => _AddOrganizationState();
}

class _AddOrganizationState extends State<AddOrganization> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                SizedBox(
                  height: Constants.screenHeight(context) * 0.04,
                ),
                Text(
                  widget.user == "admin"
                      ? "Let's add organization."
                      : "Let's signup.",
                  style: FontStyle(40, Colors.black, FontWeight.bold),
                ),
                Text(
                    widget.user == "admin"
                        ? "Admin: ELMS Secure Map"
                        : "As organization",
                    style: FontStyle(25, Colors.black, FontWeight.w300)),
                SizedBox(
                  height: Constants.screenWidth(context) * 0.08,
                ),
                Container(
                  width: Constants.screenWidth(context),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputField(
                          hint: "Enter name",
                          icon: Ionicons.person_circle,
                          controller: name),
                      InputField(
                          hint: "Enter email",
                          icon: Icons.mail,
                          controller: email),
                      InputField(
                          hint: "Enter phone",
                          icon: Icons.phone_rounded,
                          controller: phone),
                      InputAddressField(
                          hint: "Enter address",
                          icon: Icons.credit_card_rounded,
                          controller: address),
                      const SizedBox(
                        height: 5,
                      ),
                      InputPasswordField(
                          hint: "Enter Password",
                          icon: Ionicons.key,
                          controller: password),
                      InkWell(
                        onTap: () async {
                          if (!applicationBloc.loading) {
                            OrganizationModel organizationModel =
                                OrganizationModel(
                                    name: name.text,
                                    email: email.text,
                                    password: password.text,
                                    address: address.text,
                                    phone: phone.text);
                            if (await applicationBloc.addOrganization(
                                organizationModel, widget.user!)) {
                              Constants.showSnackBar(context,
                                  "Organization successfully created...", true);
                            } else {
                              Constants.showSnackBar(
                                  context,
                                  "An error occured while creating organization...",
                                  false);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          width: Constants.screenWidth(context) * 0.6,
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
                                      : widget.user == "admin"
                                          ? "Add Organization"
                                          : "Signup",
                                  textAlign: TextAlign.center,
                                  style: FontStyle(
                                      24, Colors.black54, FontWeight.bold)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
