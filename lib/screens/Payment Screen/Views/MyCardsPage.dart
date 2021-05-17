import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/alert_dialog.dart';
import '../../../components/default_button.dart';
import '../../../models/Product.dart';
import 'widgets/card_back.dart';
import 'widgets/card_front.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_stories/screens/Payment Screen/Success Screen/success.dart';

class MyCardsPage extends StatefulWidget {
  final List<Product> items;
  MyCardsPage({@required this.items});
  @override
  _MyCardsPageState createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _flipAnimationController;
  Animation<double> _flipAnimation;
  TextEditingController _cardNumberController,
      _cardHolderNameController,
      _cardExpiryController,
      _cvvController;
  FocusNode _cvvFocusNode;
  String _cardNumber = '';
  String _cardHolderName = '';
  String _cardExpiry = '';
  String _cvvNumber = '';

  _MyCardsPageState() {
    _cardNumberController = TextEditingController();
    _cardHolderNameController = TextEditingController();
    _cardExpiryController = TextEditingController();
    _cvvController = TextEditingController();
    _cvvFocusNode = FocusNode();

    _cardNumberController.addListener(onCardNumberChange);
    _cardHolderNameController.addListener(() {
      _cardHolderName = _cardHolderNameController.text;
      setState(() {});
    });
    _cardExpiryController.addListener(() {
      _cardExpiry = _cardExpiryController.text;
      setState(() {});
    });
    _cvvController.addListener(() {
      _cvvNumber = _cvvController.text;
      setState(() {});
    });

    _cvvFocusNode.addListener(() {
      _cvvFocusNode.hasFocus
          ? _flipAnimationController.forward()
          : _flipAnimationController.reverse();
    });
  }

  @override
  void initState() {
    super.initState();
    _flipAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _flipAnimation =
        Tween<double>(begin: 0, end: 1).animate(_flipAnimationController)
          ..addListener(() {
            setState(() {});
          });
//    _flipAnimationController.forward();
  }

  void onCardNumberChange() {
    _cardNumber = _cardNumberController.text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(math.pi * _flipAnimation.value),
              origin: Offset(MediaQuery.of(context).size.width / 2, 0),
              child: _flipAnimation.value < 0.5
                  ? CardFrontView(
                      cardNumber: _cardNumber,
                      cardHolderName: _cardHolderName,
                      cardExpiry: _cardExpiry,
                    )
                  : CardBackView(
                      cvvNumber: _cvvNumber,
                    ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16),
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _cardNumberController,
                        maxLength: 16,
                        decoration: InputDecoration(
                          hintText: 'Card Number',
                        ),
                      ),
                      TextField(
                        controller: _cardHolderNameController,
                        decoration: InputDecoration(
                          hintText: 'Card Holder',
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _cardExpiryController,
                              maxLength: 6,
                              decoration: InputDecoration(
                                hintText: 'Card Expiry',
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              focusNode: _cvvFocusNode,
                              controller: _cvvController,
                              maxLength: 3,
                              decoration: InputDecoration(
                                  counterText: '', hintText: 'CVV'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: DefaultButton(
                text: 'Continue',
                press: () {
                  showLoadingDialog(context);
                  for (int i = 0; i < widget.items.length; i++)
                    FirebaseFirestore.instance.collection('Orders').add({
                      'Email': FirebaseAuth.instance.currentUser.email,
                      'title': widget.items[i].title,
                      'price': widget.items[i].price,
                      'image': widget.items[i].image,
                      'status': 'Confirmed'
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser.email)
                          .collection('Cart')
                          .doc(widget.items[i].docID)
                          .delete()
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.of(context, rootNavigator: true)
                            .pushReplacement(MaterialPageRoute(
                                builder: (_) => PaymentSuccess()));
                      });
                    });
                },
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
