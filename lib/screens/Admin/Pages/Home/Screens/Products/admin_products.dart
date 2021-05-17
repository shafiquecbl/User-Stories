import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import '../../../../../../constants.dart';
import '../../../../../../models/Product.dart';
import '../../../../../../size_config.dart';
import 'Add/add_products.dart';
import 'components/product_card.dart';

class AdminProducts extends StatefulWidget {
  @override
  _AdminProductsState createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Manage Products',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
                height: getProportionateScreenWidth(46),
                width: getProportionateScreenWidth(46),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      navigatorPush(context, AddProductForm());
                    })),
          )
        ],
      ),
      body: StreamBuilder(
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
            return Center(
              child: Container(
                width: 125,
                height: 40,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      navigatorPush(context, AddProductForm());
                    },
                    icon: Icon(Icons.add),
                    label: Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: Text(
                        'Add',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )),
              ),
            );
          return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              children: List<Widget>.generate(snapshot.data.docs.length,
                  (index) => productList(snapshot.data.docs[index])));
        },
      ),
    );
  }

  Widget productList(DocumentSnapshot snapshot) {
    return MyProductCard(
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
