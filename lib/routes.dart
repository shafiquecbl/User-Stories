import 'package:flutter/widgets.dart';
import 'package:user_stories/screens/Admin/Admin.dart';
import 'package:user_stories/screens/cart/cart_screen.dart';
import 'package:user_stories/screens/forgot_password/forgot_password_screen.dart';
import 'package:user_stories/screens/Reseller/home_screen.dart';
import 'package:user_stories/screens/profile/profile_screen.dart';
import 'package:user_stories/screens/sign_in/sign_in_screen.dart';
import 'package:user_stories/screens/User Home/User_Home.dart';
import 'main.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  Home.routeName: (context) => Home(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  UserHome.routeName: (context) => UserHome(),
  AdminHome.routeName: (context) => AdminHome(),
  ResellerHome.routeName: (context) => ResellerHome(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
