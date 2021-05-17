import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminResellers extends StatefulWidget {
  @override
  _AdminResellersState createState() => _AdminResellersState();
}

class _AdminResellersState extends State<AdminResellers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Resellers'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('Role', isEqualTo: 'ReSeller')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text('No Reseller Available'),
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
    return Card(
      elevation: 2,
      shadowColor: Colors.deepPurpleAccent,
      child: ListTile(
        title: Text(snapshot['Email']),
      ),
    );
  }
}
