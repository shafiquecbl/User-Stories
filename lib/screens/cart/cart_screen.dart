import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/models/Cart.dart';
import 'package:user_stories/screens/Payment%20Screen/Views/MyCardsPage.dart';
import '../../components/default_button.dart';
import '../../models/Product.dart';
import '../../size_config.dart';
import 'components/cart_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";
  final String role;
  CartScreen({@required this.role});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User user = FirebaseAuth.instance.currentUser;
  double totalPrice = 0;
  var ds;
  int length = 0;
  bool isTrue = true;
  List<Product> item = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: body(),
      bottomNavigationBar: checkoutCard(),
    );
  }

  body() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('Cart')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.data.docs.length == 0)
          return Center(
            child: Text('Cart is Empty'),
          );

        ds = snapshot.data.docs;
        length = ds.length;
        if (isTrue) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isTrue = false;
              for (int i = 0; i < ds.length; i++) {
                totalPrice += (ds[i]['price']).toDouble();
                item.add(Product(
                    image: ds[i]['image'],
                    title: ds[i]['title'],
                    price: widget.role == 'ReSeller'
                        ? (ds[i]['price'] / 2)
                        : ds[i]['price'],
                    docID: ds[i].id,
                    description: description));
              }
            });
          });
        }
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) =>
                  cartItems(snapshot.data.docs[index])),
        );
      },
    );
  }

  cartItems(DocumentSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Dismissible(
        key: Key(''),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            totalPrice = totalPrice - snapshot['price'];
            FirebaseFirestore.instance
                .collection('Users')
                .doc(user.email)
                .collection('Cart')
                .doc(snapshot.id)
                .delete();
          });
        },
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFFFFE6E6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Spacer(),
              SvgPicture.asset("assets/icons/Trash.svg"),
            ],
          ),
        ),
        child: CartCard(
            cart: Cart(
                product: Product(
                    image: snapshot['image'],
                    title: snapshot['title'],
                    price: snapshot['price'],
                    description: ''))),
      ),
    );
  }

  checkoutCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                Spacer(),
                widget.role == "ReSeller"
                    ? Text("50% discount for Reseller")
                    : Text("Good Luck :)"),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: widget.role == 'ReSeller'
                            ? "\$${(totalPrice / 2).toStringAsFixed(2)}"
                            : "\$$totalPrice",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () {
                      if (length != 0) {
                        navigatorPush(context, MyCardsPage(items: item));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
