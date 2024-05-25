import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../login/ui/login_screen.dart';
import 'OutPutPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Contactus.dart';
import 'Profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginScreen(), // Corrected the route name
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageId = '${DateTime.now().millisecondsSinceEpoch}-${UniqueKey().hashCode}'; // Generate a unique ID using timestamp and random number
  bool _imageUploaded = false; // Flag to track if an image has been uploaded

  Future<void> uploadFileToFirebase(File file, String folderName) async {
    try {
      // Get the file extension
      String extension = file.path.split('.').last;
      // Create the file name with the unique ID and extension
      String fileName = '$imageId.$extension';

      Reference storageReference =
      FirebaseStorage.instance.ref().child('$folderName/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save file metadata to Realtime Database
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
      await databaseReference.child('files').child(imageId).set({
        'name': fileName, // Save the file name
        'url': downloadUrl,
        'timestamp': DateTime.now().toIso8601String(),
      });

      setState(() {
        _imageUploaded = true; // Set flag to true when image is uploaded
      });
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> sendImageToServer(File imageFile) async {
    try {
      var uri = Uri.parse('https://d4ff-45-247-215-166.ngrok-free.app/upload');

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        // Image uploaded successfully
        setState(() {
          _imageUploaded = true;
        });
      } else {
        // Error uploading image
        print('Error uploading image: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Exception occurred
      print('Exception uploading image: $e');
    }
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      // Get the file extension
      String extension = imageFile.path.split('.').last;
      // Create the file name with the unique ID and extension
      String fileName = '$imageId.$extension';

      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
      await storageReference.putFile(imageFile);
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadImage(imageFile);
      await sendImageToServer(imageFile);
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadImage(imageFile);
      await sendImageToServer(imageFile);
    }
  }

  Future<void> _logout(BuildContext context, String s) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page and remove all the previous routes
      Navigator.pushReplacementNamed(context, '/loginScreen');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Youssef Shahen Project',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        titleSpacing: 3.0,
        iconTheme: IconThemeData(color: Colors.white, size: 35),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu), // Menu Icon
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open Drawer on Menu Icon tap
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff003B80),
              ),
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User? user = snapshot.data;
                    if (user != null) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoURL ?? ''),
                            radius: 30, // Adjust the size as needed
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome,',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                user.displayName ?? '', // Display user's display name
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.email ?? '', // Display user's email
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }
                  return SizedBox(); // Return an empty SizedBox while waiting for user authentication state
                },
              ),
            ),
            ListTile(
              title: Text(
                'Contact US',
                style: TextStyle(color: Color(0xff003B80), fontSize: 24),
              ),
              leading: Icon(Icons.call),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()));
              },

            ),
            ListTile(
              title: Text(
                'Profile',
                style: TextStyle(color: Color(0xff003B80), fontSize: 24),
              ),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: Color(0xff003B80), fontSize: 24),
              ),
              leading: Icon(Icons.logout), // Icon for logout
              onTap: () {
                _logout(context, '/loginScreen'); // Logout the user
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                _openCamera(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
              ).merge(
                ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return Color(0xff003B80);
                    },
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff003B80),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Open Camera',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _selectImage(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
              ).merge(
                ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return Color(0xff003B80);
                    },
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.image,color: Colors.white,),
                  // Leading icon
                  SizedBox(width: 10), // Add some space between the icon and text
                  Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_imageUploaded) {
              // Navigate to the OutPutPage only if an image has been uploaded
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OutPutPage(imagename: imageId+'.jpg')),
              );
            } else {
              // Show a message if no image has been uploaded
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please upload an image before submitting.'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff003B80),
            padding: EdgeInsets.all(16.0),
            minimumSize: Size(double.infinity, 0),
          ).merge(
            ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blue;
                  }
                  return Color(0xff003B80);
                },
              ),
            ),
          ),
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
