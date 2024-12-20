import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app_flutter/screens/my_app_home_screen.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageUrl = '';
  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Uint8List? imageData;

      if (kIsWeb) {
        imageData = await pickedImage.readAsBytes();
      } else {
        final file = File(pickedImage.path);
        imageData = await file.readAsBytes();
      }

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pics')
          .child('${widget.userId}.jpg');

      try {
        await ref.putData(imageData);

        imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({'profilePicture': imageUrl});

        setState(() {});
      } catch (e) {
        print("Error uploading image: $e");
      }
    } else {
      print("No image selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.afacad(
            textStyle: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 24, color: primaryColor),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyAppHomeScreen()),
            );
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Column(
                      children: [
                        Container(
                          width: screenSize.width > 600
                              ? 130
                              : screenSize.width * 0.3,
                          height: screenSize.height > 600
                              ? 130
                              : screenSize.height * 0.3,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(100),
                              image: userData['profilePicture'] != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        userData['profilePicture'],
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage('assets/profile.png'),
                                      fit: BoxFit.cover)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: pickImage,
                              style: TextButton.styleFrom(
                                textStyle: GoogleFonts.afacad(
                                  textStyle: const TextStyle(
                                    color: secondaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              child: const Text('Change Profile Picture'),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  width: screenSize.width > 480
                      ? screenSize.width / 2.1
                      : screenSize.width,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 14, color: secondaryColor),
                            ),
                            Text(
                              userData['email'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 14, color: secondaryColor),
                            ),
                            Text(
                              userData['name'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
