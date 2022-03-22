import 'package:another_flushbar/flushbar.dart';
import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Controllers/EmployeeController.dart';
import 'package:elm_fyp/Models/EmployeeModel.dart';
import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController cnic = TextEditingController();
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
                  "Let's add new employee.",
                  style: FontStyle(40, Colors.black, FontWeight.bold),
                ),
                SizedBox(
                  height: Constants.screenWidth(context) * 0.05,
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
                      InputField(
                          hint: "Enter designation",
                          icon: Icons.chair_alt_rounded,
                          controller: designation),
                      InputField(
                          hint: "Enter CNIC",
                          icon: Icons.perm_contact_calendar_rounded,
                          controller: cnic),
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
                            EmployeeModel employeeModel = EmployeeModel(
                                name: name.text,
                                email: email.text,
                                phone: phone.text,
                                password: password.text,
                                designation: designation.text,
                                cnic: cnic.text);
                            if (await applicationBloc
                                .addEmployee(employeeModel)) {
                              Constants.showSnackBar(context,
                                  "Employee successfully created...", true);
                            } else {
                              Constants.showSnackBar(
                                  context,
                                  "An error occured while creating employee...",
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
                                      : "Add Employee",
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
