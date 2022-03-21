import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/organization/employee_list.dart';
import 'package:elm_fyp/Views/organization/organization_notification.dart';
import 'package:elm_fyp/Views/organization/organization_profile.dart';
import 'package:elm_fyp/Views/organization/regions_list.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';

const List<Widget> _screens = <Widget>[
  EmployeeList(),
  RegionsList(),
  OrganizationNotification(),
  OrganizationProfile()
];

int _selectedIndex = 1;

class OrganizationNav extends StatefulWidget {
  int initRoute = -1;
  OrganizationNav(this.initRoute, {Key? key}) : super(key: key);

  @override
  _OrganizationNavState createState() => _OrganizationNavState();
}

class _OrganizationNavState extends State<OrganizationNav> {
  late PageController _pageController;
  @override
  initState() {
    super.initState();
    if (widget.initRoute != -1) {
      _pageController = PageController(initialPage: widget.initRoute);
    } else {
      _pageController = PageController(initialPage: 1);
    }
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
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
                backgroundColor: Constants.primaryColor,
                iconActiveColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                icon: Icons.groups_rounded,
                iconSize: 30,
                text: '',
              ),
              GButton(
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Constants.primaryColor,
                iconActiveColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                icon: Ionicons.home,
                text: '',
              ),
              GButton(
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Constants.primaryColor,
                iconActiveColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                icon: Ionicons.notifications,
                text: '',
                leading: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 99 > 9 ? 20 : 10),
                      child: Icon(Ionicons.notifications,
                          color: _selectedIndex == 2
                              ? Colors.white
                              : Constants.primaryColor),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                        decoration: BoxDecoration(
                            color: _selectedIndex == 2
                                ? Colors.yellow
                                : Colors.green,
                            borderRadius: BorderRadius.circular(100)),
                        child: Text(99 > 9 ? "9+" : 99.toString(),
                            style: TextStyle(
                                color: _selectedIndex == 2
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold)))
                  ],
                ),
              ),
              GButton(
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Constants.primaryColor,
                iconActiveColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                icon: Icons.settings,
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
    );
  }
}
