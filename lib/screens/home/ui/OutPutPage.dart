import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class OutPutPage extends StatefulWidget {
  final String imagename; // Required image file name
  OutPutPage({required this.imagename});

  @override
  _OutPutPageState createState() => _OutPutPageState();
}

class _OutPutPageState extends State<OutPutPage> {
  String? gender;
  int? age;
  String? imageName;
  bool isLoading = true;
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the page is initialized
  }

  void fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://d4ff-45-247-215-166.ngrok-free.app/data'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          gender = data['gender'];
          age = data['age'];
          isLoading = false; // Set loading indicator to false when data is fetched
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> saveDataToJson() async {
    try {
      // Retrieve existing JSON data
      String existingData = await _getExistingJsonData();

      // Parse existing JSON data into a Map
      Map<String, dynamic> jsonData = json.decode(existingData);

      // Add new output data to the existing JSON data
      jsonData['output'] ??= [];
      jsonData['output'].add({
        'gender': gender,
        'age': age,
        'imageName': widget.imagename,
      });

      // Add input data to the JSON
      jsonData['input'] ??= {};
      jsonData['input']['age'] = ageController.text;
      jsonData['input']['gender'] = genderController.text;

      // Convert the updated data to JSON
      String updatedJsonData = json.encode(jsonData);

      // Upload updated JSON data to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('output_data.json');
      await storageReference.putData(utf8.encode(updatedJsonData));
    } catch (error) {
      print('Error saving data to JSON file: $error');
    }
  }

  Future<String> _getExistingJsonData() async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('output_data.json');
      final existingData = await storageReference.getData();
      if (existingData != null) {
        return utf8.decode(existingData);
      } else {
        // Return empty JSON object if no existing data
        return '{}';
      }
    } catch (error) {
      print('Error getting existing JSON data: $error');
      return '{}'; // Return empty JSON object if error occurs
    }
  }

  Future<String> getImageUrl() async {
    String? fileName = widget.imagename;
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error getting image URL: $error');
      return ''; // Return empty string if error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Output Page',
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
        child: isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(10),
                FutureBuilder<String>(
                  future: getImageUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      String imageUrl = snapshot.data ?? '';
                      return Image.network(
                        imageUrl,
                      );
                    }
                  },
                ),
                Gap(15),
                if (gender != null)
                  Text(
                    'Gender: $gender',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                if (age != null) SizedBox(height: 10),
                if (age != null)
                  Text(
                    'Age: $age',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 10), // Add spacing
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    hintText: 'Enter your age',
                  ),
                ),
                SizedBox(height: 5), // Add spacing
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(
                    hintText: 'Enter your gender',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveDataToJson();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blue;
                        }
                        return Color(0xff003B80);
                      },
                    ),
                  ),
                  child: Text('Submit',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }}
