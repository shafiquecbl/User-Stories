import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/models/Product.dart';
import 'package:user_stories/screens/Reseller/Categories/Products/guest_products.dart';
import '../constants.dart';
import '../size_config.dart';
import 'package:user_stories/screens/Reseller/Categories/Products/cat_products.dart';

class CategoriesCard extends StatelessWidget {
  CategoriesCard({
    @required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseAuth.instance.currentUser == null
            ? navigatorPush(context, GuestProducts(category: category.name))
            : navigatorPush(context, CatProducts(category: category.name));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Container(
          width: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CachedNetworkImage(
                  imageUrl: category.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/images/empty.jpg'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/images/empty.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
