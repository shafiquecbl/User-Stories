import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/screens/Admin/Pages/Home/Screens/My%20Profile/reseller_profile.dart';
import '../../../profile/components/profile_menu.dart';
import '../../../profile/components/profile_pic.dart';
import '../../../sign_in/sign_in_screen.dart';

class AdminSetting extends StatefulWidget {
  @override
  _AdminSettingState createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 40),
            ProfilePic(),
            SizedBox(height: 20),
            ProfileMenu(
              text: "My Profile",
              icon: "assets/icons/User Icon.svg",
              press: () => {navigatorPush(context, AdminProfile())},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => removeNavigator(context, SignInScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
