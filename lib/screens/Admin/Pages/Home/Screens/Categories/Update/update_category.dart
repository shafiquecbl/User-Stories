import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_stories/components/alert_dialog.dart';
import 'package:user_stories/components/snack_bar.dart';
import '../../../../../../../components/default_button.dart';
import '../../../../../../../components/form_error.dart';
import '../../../../../../../constants.dart';
import '../../../../../../../models/Product.dart';
import '../../../../../../../size_config.dart';

class UpdateCategoryForm extends StatelessWidget {
  final Category category;
  UpdateCategoryForm({@required this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Category'),
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
                CategoryUpdateForm(category: category),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryUpdateForm extends StatefulWidget {
  final Category category;
  CategoryUpdateForm({@required this.category});
  @override
  _CategoryUpdateFormState createState() => _CategoryUpdateFormState();
}

class _CategoryUpdateFormState extends State<CategoryUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String categoryName;
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
          addCategoryFormField(),
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
            text: "Update Category",
            press: () {
              if (_formKey.currentState.validate()) {
                if (categoryName == null) {
                  categoryName = widget.category.name;
                }
                if (fileName != 'File Selected') {
                  dowurl = widget.category.image;
                  showLoadingDialog(context);
                  updateCategory();
                } else {
                  showLoadingDialog(context);
                  uploadData();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField addCategoryFormField() {
    return TextFormField(
      initialValue: widget.category.name,
      onSaved: (newValue) => categoryName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Please add Category');
          categoryName = value;
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Please add Category');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Category",
        hintText: "Enter category name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.category),
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

  uploadData() async {
    Reference sref = FirebaseStorage.instance
        .ref()
        .child('Categories/${_image.path.split('/').last}');
    sref.putFile(_image).then((value) async {
      // ignore: unnecessary_cast
      dowurl = await sref.getDownloadURL() as String;
      await updateCategory();
    });
  }

  updateCategory() {
    return FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.category.docID)
        .update({'Name': categoryName, 'image': dowurl}).then((value) {
      _formKey.currentState.reset();
      Navigator.maybePop(context).then((value) {
        _formKey.currentState.reset();
        Snack_Bar.show(context, 'Category updated successfully');
      });
    });
  }
}
