import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    Widget image = Image.asset(
      "assets/images/nullUser.png",
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: user.photoURL == null || user.photoURL == ''
                  ? image
                  : CachedNetworkImage(
                      imageUrl: user.photoURL,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => image,
                      errorWidget: (context, url, error) => image),
            ),
          ),
        ],
      ),
    );
  }
}
