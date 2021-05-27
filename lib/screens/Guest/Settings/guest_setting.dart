import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/screens/sign_in/sign_in_screen.dart';

import '../../../constants.dart';

class GuestSettings extends StatefulWidget {
  @override
  _GuestSettingsState createState() => _GuestSettingsState();
}

class _GuestSettingsState extends State<GuestSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 140,
          child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
              ),
              onPressed: () {
                navigatorPush(context, SignInScreen());
              },
              icon: Icon(Icons.login),
              label: Text('Login')),
        ),
      ),
    );
  }
}
