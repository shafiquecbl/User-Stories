import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import '../../../models/Cart.dart';
import '../../../models/Product.dart';
import '../../cart/components/cart_card.dart';
import 'package:user_stories/screens/Track Order Page/track_order.dart';

class ResellerOrders extends StatefulWidget {
  @override
  _ResellerOrdersState createState() => _ResellerOrdersState();
}

class _ResellerOrdersState extends State<ResellerOrders> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('Email', isEqualTo: user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data.docs.length == 0)
            Center(
              child: Text('No Order yet'),
            );
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return myOrders(snapshot.data.docs[index]);
            },
          );
        },
      ),
    );
  }

  myOrders(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () {
        navigatorPush(
            context,
            TrackOrderPage(
              title: snapshot['title'],
              status: snapshot['status'],
            ));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: CartCard(
            cart: Cart(
                product: Product(
                    image: snapshot['image'],
                    title: snapshot['title'],
                    price: snapshot['price'],
                    description: ''))),
      ),
    );
  }
}
