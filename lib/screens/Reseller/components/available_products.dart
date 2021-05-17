import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/product_card.dart';
import 'package:user_stories/models/Product.dart';

class AvailableProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .orderBy('title', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.docs.length == 0)
          return Center(child: Text('No Products Available'));
        return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            children: List<Widget>.generate(snapshot.data.docs.length,
                (index) => productList(snapshot.data.docs[index])));
      },
    );
  }

  Widget productList(DocumentSnapshot snapshot) {
    return ProductCard(
      product: Product(
          title: snapshot['title'],
          description: snapshot['description'],
          price: snapshot['price'],
          image: snapshot['image'],
          category: snapshot['category'],
          stock: snapshot['stock'],
          docID: snapshot.id),
    );
  }
}
