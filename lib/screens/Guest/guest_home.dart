import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../../constants.dart';
import 'Home/guest_home.dart';
import 'Settings/guest_setting.dart';

class Guest extends StatefulWidget {
  static String routeName = "/Admin_home";
  @override
  _GuestState createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: <Widget>[GuestHome(), GuestSettings()],
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Center(child: Text('Home')),
              icon: Icon(Icons.home),
              activeColor: kPrimaryColor,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              title: Center(child: Text('Setting')),
              icon: Icon(Icons.settings),
              activeColor: kPrimaryColor,
              inactiveColor: Colors.grey),
        ],
      ),
    );
  }
}
