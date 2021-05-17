import 'package:flutter/material.dart';
import 'package:user_stories/screens/Reseller/components/icon_btn_with_counter.dart';
import 'package:user_stories/screens/Reseller/components/available_products.dart';

import '../../cart/cart_screen.dart';

class ResellerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Available Products'),
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
        child: AvailableProducts(),
      ),
    );
  }
}
