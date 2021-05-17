import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_stories/components/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_stories/components/snack_bar.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Edit Profile",
              style: GoogleFonts.teko(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.grey[100],
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  EditProfileForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  String name;
  String phoneNo;
  String address;

  String storeName;
  String storePhoneNo;
  String storeAddress;

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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          storeName = snapshot.data['Name'];
          storePhoneNo = snapshot.data['PhoneNo'];
          storeAddress = snapshot.data['Address'];
          return Form(
            key: _formKey,
            child: Column(
              children: [
                getNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getPhoneNoFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                getAddressFormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(40)),
                DefaultButton(
                    text: "Update Profile",
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        if (name == null) {
                          name = storeName;
                        }
                        if (phoneNo == null) {
                          phoneNo = storePhoneNo;
                        }
                        if (address == null) {
                          address = storeAddress;
                        }
                        showLoadingDialog(context);
                        editProfile();
                      }
                    }),
                SizedBox(height: getProportionateScreenHeight(10)),
              ],
            ),
          );
        });
  }

  ///////////////////////////////////////////////////////////////////////////////
  TextFormField getNameFormField() {
    return TextFormField(
      initialValue: storeName,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
          name = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  TextFormField getPhoneNoFormField() {
    return TextFormField(
      maxLength: 13,
      keyboardType: TextInputType.phone,
      initialValue: storePhoneNo,
      onSaved: (newValue) => phoneNo = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
          phoneNo = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone No",
        hintText: "Enter Phone No",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////

  Container getAddressFormField() {
    return Container(
      height: 150,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        initialValue: storeAddress,
        onSaved: (newValue) => address = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kAddressNullError);
            address = value;
          } else {}
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kAddressNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Address",
          hintText: "Enter your address",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
        ),
      ),
    );
  }

  editProfile() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({'Name': name, 'PhoneNo': phoneNo, 'Address': address}).then(
            (value) {
      Navigator.maybePop(context)
          .then((value) => Snack_Bar.show(context, 'Profile Updated!'));
    });
  }
}
