import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/routes.dart';
import 'package:user_stories/screens/Admin/Admin.dart';
import 'package:user_stories/theme.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'package:user_stories/screens/Reseller/home_screen.dart';
import 'size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Stories',
      theme: theme(),
      initialRoute: user != null ? Home.routeName : SignInScreen.routeName,
      routes: routes,
    );
  }
}

class Home extends StatelessWidget {
  static String routeName = "/home";
  final User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('Users').doc(user.email).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) return loading();
        if (snapshot.data['Role'] == "Admin")
          SchedulerBinding.instance.addPostFrameCallback((_) {
            removeNavigator(context, AdminHome());
          });
        else {
          if (user.emailVerified) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              removeNavigator(context, ResellerHome());
            });
          }
        }
        return loading();
      },
    );
  }

  loading() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
