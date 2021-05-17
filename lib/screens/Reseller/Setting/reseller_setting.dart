import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import '../../profile/components/profile_menu.dart';
import '../../profile/components/profile_pic.dart';
import '../../sign_in/sign_in_screen.dart';
import 'package:user_stories/screens/Reseller/My Order/reseller_orders.dart';
import 'package:user_stories/screens/Reseller/My Profile/reseller_profile.dart';

class ResellerSetting extends StatefulWidget {
  @override
  _ResellerSettingState createState() => _ResellerSettingState();
}

class _ResellerSettingState extends State<ResellerSetting> {
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
              press: () => {navigatorPush(context, ResellerProfile())},
            ),
            ProfileMenu(
              text: "My Orders",
              icon: "assets/icons/Parcel.svg",
              press: () => {navigatorPush(context, ResellerOrders())},
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
