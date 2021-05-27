import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_stories/components/alert_dialog.dart';
import 'package:user_stories/constants.dart';
import 'package:user_stories/screens/Admin/Pages/Home/Screens/Profiles/edit_profile.dart';
import 'package:user_stories/screens/Reseller/My%20Profile/edit_profile.dart';
import 'package:user_stories/size_config.dart';

class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  Widget image = Image.asset(
    "assets/images/nullUser.png",
    width: 120,
    height: 120,
    fit: BoxFit.cover,
  );
  File _image;
  var dowurl;
  User user = FirebaseAuth.instance.currentUser;
  String email = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "My Profile",
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => EditUserProfile(
                      userEmail: FirebaseAuth.instance.currentUser.email,
                    ),
                  ),
                );
              },
            ),
          ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(email)
                      .snapshots();
                });
              },
              child: ListView(children: [
                Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(30)),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: user.photoURL == null
                                    ? image
                                    : CachedNetworkImage(
                                        imageUrl: user.photoURL,
                                        width: 125,
                                        height: 125,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            image),
                              )),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                    color: kPrimaryColor,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  _imgFromGallery();
                                },
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      snapshot.data['Name'],
                      style: GoogleFonts.teko(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Phone No.',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['PhoneNo'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Address',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['Address'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  _imgFromGallery() async {
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
      uploadProfilePic();
    });
  }

  uploadProfilePic() async {
    showLoadingDialog(context);
    final sref =
        FirebaseStorage.instance.ref().child('Profile Pics/$email.jpg');
    sref.putFile(_image).then((value) async {
      // ignore: unnecessary_cast
      dowurl = await sref.getDownloadURL() as String;
      await pop(dowurl);
    });
  }

  pop(dowurl) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({'ProfileURL': dowurl});
    await user.updateProfile(photoURL: dowurl).then((value) {
      print('DONEEEEEEEEE');
      Navigator.pop(context);
    });
  }
}
