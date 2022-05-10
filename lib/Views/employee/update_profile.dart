import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EmployeeProfileUpdate extends StatefulWidget {
  const EmployeeProfileUpdate({Key? key}) : super(key: key);

  @override
  _EmployeeProfileUpdateState createState() => _EmployeeProfileUpdateState();
}

class _EmployeeProfileUpdateState extends State<EmployeeProfileUpdate> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController cnic = TextEditingController();
  String dropdownvalue = "Male";
  var items = [
    'Male',
    'Female',
  ];
  @override
  void initState() {
    name.text = Constants.employee.name.toString();
    email.text = Constants.employee.email.toString();
    phone.text = Constants.employee.phone.toString();
    designation.text = Constants.employee.designation.toString();
    cnic.text = Constants.employee.cnic.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
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
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Constants.primaryColor,
                      size: 25,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Let's update.",
                    style: FontStyle(28, Colors.black, FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: Constants.screenWidth(context) * 0.05,
              ),
              Container(
                // height: Constants.screenHeight(context) * 0.65,
                width: Constants.screenWidth(context),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputField(
                        hint: "Aun Shahbaz",
                        icon: Ionicons.person_circle,
                        controller: name),
                    InputField(
                        hint: "aunshahbaz@gmail.com",
                        icon: Icons.mail,
                        controller: email),
                    InputField(
                        hint: "37405-1647734-5",
                        icon: Icons.phone,
                        controller: phone),
                    InputField(
                        hint: "designation",
                        icon: Icons.align_vertical_bottom_rounded,
                        controller: designation),
                    InputField(
                        hint: "CNIC",
                        icon: Icons.credit_card_sharp,
                        controller: cnic),
                    InputPasswordField(
                        hint: "New Password (Optional)",
                        icon: Ionicons.key,
                        controller: password),
                    InkWell(
                      onTap: () {
                        //authServices.login(email.text, password.text);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                        width: Constants.screenWidth(context) * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text("Update Profile",
                            textAlign: TextAlign.center,
                            style:
                                FontStyle(24, Colors.black54, FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
