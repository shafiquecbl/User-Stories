import 'package:flutter/material.dart';
import 'package:user_stories/screens/Reseller/components/available_categories.dart';
import 'package:user_stories/screens/Reseller/components/icon_btn_with_counter.dart';
import '../../../size_config.dart';
import '../../cart/cart_screen.dart';

class ResellerCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Available Categgories'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 5),
            child: IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icon.svg",
              press: () => Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AvailableCategories(),
      ),
    );
  }
}
