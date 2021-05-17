import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/screens/Reseller/home_screen.dart';
import '../../../components/default_button.dart';
import '../../../size_config.dart';

class PaymentSuccess extends StatelessWidget {
  static String routeName = "/payment_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Success"),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Payment Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              removeNavigator(context, ResellerHome());
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
