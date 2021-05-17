import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';

import '../sign_in/sign_in_screen.dart';

class UserHome extends StatefulWidget {
  static String routeName = "/User_home";
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Home'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => removeNavigator(context, SignInScreen()));
              })
        ],
      ),
      body: Center(
        child: Text('User Home'),
      ),
    );
  }
}
