import 'package:flutter/material.dart';
import 'package:user_stories/screens/Reseller/components/available_categories.dart';
import 'package:user_stories/screens/Reseller/components/available_products.dart';

class GuestHome extends StatefulWidget {
  @override
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Home'),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 20),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          AvailableCategories(),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text(
              'Available Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: AvailableProducts()),
        ],
      )),
    );
  }
}
