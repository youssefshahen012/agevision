import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Profile Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),

      body: Center( // Center widget added here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: NetworkImage(_user.photoURL ?? ''),), // Adjust width and height as needed
              SizedBox(height: 20),
              Text(
                'Name: ${_user.displayName ?? 'No Name'}',
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ${_user.email ?? 'No Email'}',
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
