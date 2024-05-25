import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Contact Us',
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(10),
                // Image widget with a network image URL
                // Replace 'imageUrl' with your actual image URL
                Image.network(
                  'https://aast.edu/template/en/colleges-all/img/logo-blue03.webp',
                ),
                Gap(15),
                // Some text here if needed
                Text(
                  'Age Vision APP',
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
                ),
                SizedBox(height: 10), // Adding space between lines
                Text(
                  'Email: yshahen80@gmail.com',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
                ),
                SizedBox(height: 10), // Adding space between lines
                Text(
                  'Supervisor',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
                ),
                SizedBox(height: 10), // Adding space between lines
                Text(
                  'Dr: Osama Badway',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
                ),
                SizedBox(height: 10), // Adding space between lines
                Text(
                  'Eng: Rawan Mohamed Saad',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
                ),
                SizedBox(height: 10), // Adding space between lines
                Text(
                  'Eng: Youssef Hesham Shahen',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff003B80)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
