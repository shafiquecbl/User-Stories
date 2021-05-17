import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_stories/components/alert_dialog.dart';
import 'package:user_stories/components/snack_bar.dart';
import '../../../../../../../components/default_button.dart';
import '../../../../../../../components/form_error.dart';
import '../../../../../../../size_config.dart';

class AddProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                ProductForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String title;
  String category;
  String description;
  double price;
  int stock;
  String fileName = "No Image Selected";

  File _image;
  var dowurl;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          productTitle(),
          SizedBox(height: getProportionateScreenHeight(30)),
          productCategory(),
          SizedBox(height: getProportionateScreenHeight(30)),
          productDescription(),
          SizedBox(height: getProportionateScreenHeight(30)),
          productPrice(),
          SizedBox(height: getProportionateScreenHeight(30)),
          productStock(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$fileName",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    _imgFromGallery();
                  },
                  icon: Icon(Icons.attach_file),
                  label: Text('Select Image'))
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Add Product",
            press: () {
              if (_formKey.currentState.validate()) {
                if (fileName != 'Image Selected') {
                  addError(error: 'Please select image');
                } else {
                  removeError(error: 'Please select image');
                  showLoadingDialog(context);
                  uploadProfilePic();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField productTitle() {
    return TextFormField(
      onSaved: (newValue) => title = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Enter Product Title');
          title = value;
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Enter Product Title');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Enter product title",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.title),
      ),
    );
  }

  TextFormField productCategory() {
    return TextFormField(
      onSaved: (newValue) => category = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Enter Product category');
          category = value;
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Enter Product category');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Category",
        hintText: "Enter product category",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.category),
      ),
    );
  }

  Widget productDescription() {
    return Container(
      height: 150,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        onSaved: (newValue) => description = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: 'Enter Product Description');
            description = value;
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: 'Enter Product Description');
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Description",
          hintText: "Enter product description",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.description),
        ),
      ),
    );
  }

  TextFormField productPrice() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => price = double.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Enter Product Price');
          price = double.parse(value);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Enter Product Price');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Price",
        hintText: "Enter product price",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.money),
      ),
    );
  }

  TextFormField productStock() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => stock = int.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Enter Product Stock');
          stock = int.parse(value);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Enter Product Stock');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Stock",
        hintText: "Enter product stock",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.widgets),
      ),
    );
  }

  _imgFromGallery() async {
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
      fileName = 'Image Selected';
    });
  }

  uploadProfilePic() async {
    Reference sref = FirebaseStorage.instance
        .ref()
        .child('Products/${_image.path.split('/').last}');
    sref.putFile(_image).then((value) async {
      // ignore: unnecessary_cast
      dowurl = await sref.getDownloadURL() as String;
      await addProduct();
    });
  }

  addProduct() {
    return FirebaseFirestore.instance.collection('Products').doc().set({
      'title': title,
      'category': category,
      'description': description,
      'price': price,
      'stock': stock,
      'image': dowurl
    }).then((value) {
      _formKey.currentState.reset();
      Navigator.maybePop(context).then(
          (value) => Snack_Bar.show(context, 'Product added successfully'));
    });
  }
}
