import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import 'card.dart';
import 'Screens/Categories/Categories.dart';
import 'Screens/Products/admin_products.dart';
import 'Screens/ReSellers/admin_reseller.dart';
import 'Screens/Users/admin_user.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Welcome Admin',
        ),
      ),
      body: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 4 : 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          children: [categories(), products(), users(), reSellers()]),
    );
  }

  categories() {
    return DashboardCard(
      icon: Icon(
        Icons.category,
        color: kPrimaryColor,
        size: 50,
      ),
      title: 'Catgories',
      screen: AdminCategories(),
    );
  }

  products() {
    return DashboardCard(
      icon: Icon(
        Icons.widgets,
        color: kPrimaryColor,
        size: 50,
      ),
      title: 'Products',
      screen: AdminProducts(),
    );
  }

  users() {
    return DashboardCard(
      icon: Icon(
        Icons.person,
        color: kPrimaryColor,
        size: 50,
      ),
      title: 'Users',
      screen: AdminUsers(),
    );
  }

  reSellers() {
    return DashboardCard(
      icon: Icon(
        Icons.group,
        color: kPrimaryColor,
        size: 50,
      ),
      title: 'ReSellers',
      screen: AdminResellers(),
    );
  }
}
