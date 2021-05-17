import 'package:flutter/material.dart';

navigatorPush(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (builder) => screen));
}

rootNavigator(BuildContext context, Widget screen) {
  return Navigator.of(context, rootNavigator: true)
      .push(MaterialPageRoute(builder: (builder) => screen));
}

removeNavigator(BuildContext context, Widget screen) {
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (Route<dynamic> route) => false);
}
