import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import '../../../../../../constants.dart';
import '../../../../../../models/Product.dart';
import '../../../../../../size_config.dart';
import 'Add/add_categories.dart';
import 'package:user_stories/screens/Admin/Pages/Home/Screens/Products/components/category_card.dart';

class AdminCategories extends StatefulWidget {
  @override
  _AdminCategoriesState createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Manage Categories',
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
                      navigatorPush(context, AddCategoryForm());
                    })),
          )
        ],
      ),
      body: StreamBuilder(
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
                      navigatorPush(context, AddCategoryForm());
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
                  (index) => categoryList(snapshot.data.docs[index])));
        },
      ),
    );
  }

  Widget categoryList(DocumentSnapshot snapshot) {
    return MyCategoryCard(
        category: Category(
      image: snapshot['image'],
      name: snapshot['Name'],
      docID: snapshot.id,
    ));
  }
}
