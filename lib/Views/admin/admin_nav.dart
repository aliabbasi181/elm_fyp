import 'package:elm_fyp/Views/admin/admin_profile.dart';
import 'package:elm_fyp/Views/admin/organizations_list.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

const List<Widget> _screens = <Widget>[OrganizationsList(), AdminProfile()];

int _selectedIndex = 0;

class AdminNav extends StatefulWidget {
  AdminNav({Key? key}) : super(key: key);

  @override
  _AdminNavState createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  PageController _pageController = PageController();
  @override
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
            padding: EdgeInsets.only(bottom: 8, top: 8),
            child: GNav(
              backgroundColor: Constants.primaryColor,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              activeColor: Colors.black,
              iconSize: 24,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: 5,
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Constants.primaryColor,
              tabs: [
                GButton(
                  borderRadius: BorderRadius.circular(15),
                  backgroundColor: Colors.white,
                  iconColor: Colors.white,
                  iconActiveColor: Constants.primaryColor,
                  padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                  icon: Icons.groups_rounded,
                  iconSize: 25,
                  text: '',
                  margin: const EdgeInsets.only(right: 10),
                ),
                GButton(
                  borderRadius: BorderRadius.circular(15),
                  backgroundColor: Colors.white,
                  iconColor: Colors.white,
                  iconActiveColor: Constants.primaryColor,
                  padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                  icon: Icons.settings,
                  text: '',
                  margin: const EdgeInsets.only(left: 10),
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
