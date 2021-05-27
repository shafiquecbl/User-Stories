import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import '../../constants.dart';
import '../complete_profile/complete_profile_screen.dart';

class VerifyEmail extends StatefulWidget {
  final String role;
  VerifyEmail({@required this.role});
  static String routeName = "/verify_email";

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  String email = FirebaseAuth.instance.currentUser.email;
  Timer timer;
  String token;

  @override
  void initState() {
    user = auth.currentUser;
    if (!user.emailVerified) {
      user.sendEmailVerification();
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
      super.initState();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            Text(
              "Verification link has been sent to: ",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6)),
            ),
            Text(
              "$email",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: kPrimaryColor),
            ),
            SizedBox(height: 5),
            Text("( Verify first to continue! )",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.greenAccent)),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      navigatorPush(context, CompleteProfileScreen());
      FirebaseFirestore.instance.collection('Users').doc(email).set({
        'Email': user.email,
        'Role': widget.role,
      });
    }
  }
}
