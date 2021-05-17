import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/models/Product.dart';
import '../../../../../../../constants.dart';
import '../../../../../../../size_config.dart';
import 'package:user_stories/screens/Admin/Pages/Home/Screens/Categories/Update/update_category.dart';

class MyCategoryCard extends StatelessWidget {
  MyCategoryCard({
    @required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            padding: EdgeInsets.all(getProportionateScreenWidth(10)),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Hero(
              tag: category.name,
              child: CachedNetworkImage(
                imageUrl: category.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image(
                  image: AssetImage('assets/images/empty.jpg'),
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            category.name,
            style: TextStyle(color: Colors.black),
            maxLines: 2,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    iconSize: 20,
                    color: Colors.white,
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      navigatorPush(
                          context, UpdateCategoryForm(category: category));
                    }),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    iconSize: 20,
                    color: Colors.white,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDeletedDialog(context);
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  showDeletedDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Delete'),
            content: Text('Do you want to delete ${category.name}'),
            actions: [
              CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  FirebaseFirestore.instance
                      .collection('Categories')
                      .doc(category.docID)
                      .delete();
                },
              )
            ],
          );
        });
  }
}
