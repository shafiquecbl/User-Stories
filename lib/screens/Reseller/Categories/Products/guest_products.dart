import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../components/product_card.dart';
import '../../../../models/Product.dart';

class GuestProducts extends StatefulWidget {
  final String category;
  GuestProducts({@required this.category});

  @override
  _GuestProductsState createState() => _GuestProductsState();
}

class _GuestProductsState extends State<GuestProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.category),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .where('category', isEqualTo: widget.category)
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
                childAspectRatio: 0.7,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                children: List<Widget>.generate(snapshot.data.docs.length,
                    (index) => productList(snapshot.data.docs[index])));
          },
        ),
      ),
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
