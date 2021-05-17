import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/default_button.dart';
import 'package:user_stories/components/snack_bar.dart';
import 'package:user_stories/models/Product.dart';
import 'package:user_stories/size_config.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final Product product;
  Body({Key key, @required this.product});
  final User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: product,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return snapshot.data['Role'] == 'ReSeller'
                      ? TopRoundedContainer(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.15,
                              right: SizeConfig.screenWidth * 0.15,
                              bottom: getProportionateScreenWidth(40),
                              top: getProportionateScreenWidth(15),
                            ),
                            child: DefaultButton(
                              text: "Add To Cart",
                              press: () {
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user.email)
                                    .collection('Cart')
                                    .add({
                                  'title': product.title,
                                  'description': product.description,
                                  'price': product.price,
                                  'image': product.image,
                                }).then((value) => Snack_Bar.show(
                                        context, 'Added to Cart'));
                              },
                            ),
                          ),
                        )
                      : Container();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
