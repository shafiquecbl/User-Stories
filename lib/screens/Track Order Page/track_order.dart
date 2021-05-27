import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TrackOrderPage extends StatefulWidget {
  final String title, status, docID;
  TrackOrderPage(
      {@required this.title, @required this.status, @required this.docID});
  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  String role;
  TextStyle contentStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'sfpro');
  @override
  @override
  Widget build(BuildContext context) {
    getRole();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.status == 'Confirmed'
                  ? "Order confirmed. Ready to pick"
                  : widget.status == 'Picked Up'
                      ? "Order Picked Up. Ready to ship"
                      : "Order Shipped. Ready to deliver",
              style: contentStyle.copyWith(color: Colors.grey, fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 1,
              color: Colors.grey,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 13, top: 50),
                  width: 4,
                  height: 400,
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    statusWidget('confirmed', "Confirmed",
                        widget.status == 'Confirmed' ? true : false),
                    statusWidget('onBoard2', "Picked Up",
                        widget.status == 'Picked Up' ? true : false),
                    statusWidget('shipped', "Shipped",
                        widget.status == 'Shipped' ? true : false),
                    statusWidget('Delivery', "Delivered",
                        widget.status == 'Delivered' ? true : false),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.orange,
                      )),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Cancel Order",
                      style: contentStyle.copyWith(color: Colors.orange),
                    ),
                  ),
                ),
                role == 'Admin' && widget.status == 'Confirmed'
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.orange,
                            )),
                        child: TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('Orders')
                                .doc(widget.docID)
                                .update({'status': 'Picked Up'}).then((value) =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop());
                          },
                          child: Text(
                            "Mark as Picked Up",
                            style: contentStyle.copyWith(color: Colors.orange),
                          ),
                        ),
                      )
                    : role == 'Admin' && widget.status == 'Picked Up'
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Colors.orange,
                                )),
                            child: TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Orders')
                                    .doc(widget.docID)
                                    .update({'status': 'Shipped'}).then(
                                        (value) => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop());
                              },
                              child: Text(
                                "Mark as Shipped",
                                style:
                                    contentStyle.copyWith(color: Colors.orange),
                              ),
                            ),
                          )
                        : role == 'Admin' && widget.status == 'Shipped'
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                      color: Colors.orange,
                                    )),
                                child: TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('Orders')
                                        .doc(widget.docID)
                                        .update({'status': 'Delivered'}).then(
                                            (value) => Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop());
                                  },
                                  child: Text(
                                    "Mark as Delivered",
                                    style: contentStyle.copyWith(
                                        color: Colors.orange),
                                  ),
                                ),
                              )
                            : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  getRole() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        role = value['Role'];
      });
    });
  }

  Container statusWidget(String img, String status, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive) ? Colors.orange : Colors.white,
                border: Border.all(
                    color: (isActive) ? Colors.transparent : Colors.orange,
                    width: 3)),
          ),
          SizedBox(
            width: 50,
          ),
          Column(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/$img.png"),
                        fit: BoxFit.contain)),
              ),
              Text(
                status,
                style: contentStyle.copyWith(
                    color: (isActive) ? Colors.orange : Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }
}
