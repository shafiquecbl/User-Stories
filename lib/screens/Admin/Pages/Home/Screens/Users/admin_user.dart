import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_stories/components/navigator.dart';
import 'package:user_stories/screens/Admin/Pages/Home/Screens/Profiles/reseller_profile.dart';

class AdminUsers extends StatefulWidget {
  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('Role', isEqualTo: 'User')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text('No User Available'),
            );
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return userList(snapshot.data.docs[index]);
            },
          );
        },
      ),
    );
  }

  userList(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () {
        navigatorPush(context, ViewProfiles(userEmail: snapshot['Email']));
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.deepPurpleAccent,
        child: ListTile(
          leading: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[100],
                  child: snapshot['PhotoURL'] == null ||
                          snapshot['PhotoURL'] == ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/nullUser.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: snapshot['PhotoURL'],
                            placeholder: (context, url) => Image(
                              image: AssetImage('assets/images/nullUser.png'),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ))),
          title: Text(snapshot['Email']),
          subtitle: Text(snapshot['Name']),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
