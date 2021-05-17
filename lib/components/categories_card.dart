import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/models/Product.dart';
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
        navigatorPush(context, CatProducts(category: category.name));
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: 160,
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
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
