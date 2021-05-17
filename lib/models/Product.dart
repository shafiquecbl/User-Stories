import 'package:flutter/material.dart';

class Product {
  final String title, description, image, category, docID;
  final double price;
  final int stock;

  Product(
      {@required this.image,
      @required this.title,
      @required this.price,
      @required this.description,
      this.stock,
      this.category,
      this.docID});
}

class Category {
  final String name, image, docID;

  Category({@required this.image, @required this.name, @required this.docID});
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    image: "assets/images/ps4_console_white_1.png",
    title: "Wireless Controller for PS4™",
    price: 64.99,
    description: description,
  ),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
