import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:toddlyybeta/assets/icon_class_icons.dart';
import 'package:toddlyybeta/screens/display_baby_profile.dart';
import 'package:toddlyybeta/screens/display_bookings.dart';
import 'package:toddlyybeta/screens/display_user_profile.dart';
import 'package:toddlyybeta/screens/list_daycares.dart';
import 'package:toddlyybeta/screens/show_daycare_details.dart';

class BottomNavBar extends StatefulWidget {
  final int currentScreen;
  const BottomNavBar({Key? key, required this.currentScreen}) : super(key: key);
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final screens = [
    ListDaycares(),
    DisplayBookings(),
    DisplayBabyProfileScreen(),
    DisplayUserProfilePage(),
  ];
  int currentIndex = -1;
  @override
  Widget build(BuildContext context) {
    currentIndex = (currentIndex == -1) ? widget.currentScreen : currentIndex;

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(

          // color: Colors.deepOrange,
          // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              selectedIndex: currentIndex,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              padding: EdgeInsets.all(16),
              backgroundColor: Colors.orange,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.orangeAccent,
              gap: 8,
              tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.event, text: "Bookings"),
            GButton(icon: IconClass.baby_head_with_a_small_heart_outline, text: "Baby Profile"),
            GButton(icon: Icons.account_circle, text: 'User Profile'),
          ])),
    );
  }
}
