import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/categories_card.dart';
import 'package:user_stories/models/Product.dart';

class AvailableCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Categories')
          .orderBy('Name', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.docs.length == 0)
          return Center(child: Text('No Categories Available'));
        return Container(
          width: MediaQuery.of(context).size.width,
          // color: Colors.grey[100],
          padding: EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  children: List<Widget>.generate(snapshot.data.docs.length,
                      (index) => categoryList(snapshot.data.docs[index]))),
            ),
          ),
        );
      },
    );
  }

  Widget categoryList(DocumentSnapshot snapshot) {
    return CategoriesCard(
      category: Category(
          image: snapshot['image'], name: snapshot['Name'], docID: snapshot.id),
    );
  }
}
