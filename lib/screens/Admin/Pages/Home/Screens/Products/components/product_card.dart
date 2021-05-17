import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/models/Product.dart';
import '../../../../../../../constants.dart';
import '../../../../../../../size_config.dart';
import 'package:user_stories/screens/Admin/Pages/Home/Screens/Products/Update/update_products.dart';

import '../../../../../../details/details_screen.dart';

class MyProductCard extends StatelessWidget {
  MyProductCard({
    @required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorPush(context, DetailsScreen(product: product));
      },
      child: Container(
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
                tag: product.title,
                child: CachedNetworkImage(
                  imageUrl: product.image,
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
              product.title,
              style: TextStyle(color: Colors.black),
              maxLines: 2,
            ),
            Text(
              "\$${product.price}",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
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
                        navigatorPush(context, UpdateProduct(product: product));
                      }),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50)),
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
      ),
    );
  }

  showDeletedDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Delete'),
            content: Text('Do you want to delete ${product.title}'),
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
                      .collection('Products')
                      .doc(product.docID)
                      .delete();
                },
              )
            ],
          );
        });
  }
}
