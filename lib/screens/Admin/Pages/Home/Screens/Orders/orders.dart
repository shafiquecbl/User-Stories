import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/models/Cart.dart';
import 'package:user_stories/models/Product.dart';
import 'package:user_stories/screens/Track%20Order%20Page/track_order.dart';
import 'package:user_stories/screens/cart/components/cart_card.dart';

class ViewOrders extends StatefulWidget {
  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text('No Orders yet'),
            );
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return orderList(snapshot.data.docs[index]);
            },
          );
        },
      ),
    );
  }

  orderList(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () {
        navigatorPush(
            context,
            TrackOrderPage(
              title: snapshot['title'],
              status: snapshot['status'],
              docID: snapshot.id,
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
