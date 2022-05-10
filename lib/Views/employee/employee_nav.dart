import 'dart:async';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/employee/employee_history.dart';
import 'package:elm_fyp/Views/employee/employee_notification.dart';
import 'package:elm_fyp/Views/employee/employee_profile.dart';
import 'package:elm_fyp/Views/employee/home.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';

List<Widget> _screens = <Widget>[
  EmployeeHistory(
    employeeId: "dsadfds",
  ),
  EmployeeHome(),
  EmployeeNotification(),
  EmployeeProfile()
];

int _selectedIndex = 1;

class EmployeeNav extends StatefulWidget {
  int initRoute = -1;
  EmployeeNav(this.initRoute, {Key? key}) : super(key: key);

  @override
  _EmployeeNavState createState() => _EmployeeNavState();
}

class _EmployeeNavState extends State<EmployeeNav> {
  late PageController _pageController;
  Timer? timer;
  @override
  initState() {
    super.initState();
    _selectedIndex = widget.initRoute;
    if (widget.initRoute != -1) {
      _pageController = PageController(initialPage: widget.initRoute);
    } else {
      _pageController = PageController(initialPage: 1);
    }
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
    //   print(DateTime.now());
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        controller: _pageController,
        itemCount: _screens.length,
        itemBuilder: (context, index) {
          return _screens[index];
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Constants.primaryColor,
            border: Border(top: BorderSide(color: Colors.white))),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 8),
            child: GNav(
              backgroundColor: Constants.primaryColor,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              activeColor: Colors.black,
              iconSize: 24,
              gap: 5,
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Constants.primaryColor,
              tabs: [
                // GButton(
                //   borderRadius: BorderRadius.circular(15),
                //   backgroundColor: Constants.pinkColor,
                //   iconActiveColor: Colors.white,
                //   padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                //   icon: Icons.near_me_rounded,
                //   iconSize: 30,
                //   text: '',
                // ),
                GButton(
                  borderRadius: BorderRadius.circular(15),
                  backgroundColor: Colors.white,
                  iconColor: Colors.white,
                  iconActiveColor: Constants.primaryColor,
                  padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                  icon: Icons.history,
                  iconSize: 25,
                  text: '',
                ),
                GButton(
                  borderRadius: BorderRadius.circular(15),
                  backgroundColor: Colors.white,
                  iconColor: Colors.white,
                  iconActiveColor: Constants.primaryColor,
                  padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                  icon: Ionicons.home,
                  text: '',
                ),
                GButton(
                  borderRadius: BorderRadius.circular(15),
                  backgroundColor: Colors.white,
                  iconColor: Colors.white,
                  iconActiveColor: Constants.primaryColor,
                  padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                  icon: Ionicons.notifications,
                  text: '',
                ),

                GButton(
                  borderRadius: BorderRadius.circular(15),
                  backgroundColor: Colors.white,
                  iconColor: Colors.white,
                  iconActiveColor: Constants.primaryColor,
                  padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                  icon: Icons.person,
                  text: '',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  _screens[index];
                  _pageController.jumpToPage(index);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
