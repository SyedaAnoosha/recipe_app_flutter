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

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    print('${file?.path}');
    if (file == null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child('profile_pics');
    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = referenceImageToUpload.getDownloadURL().toString();
    } catch (error) {
      print('Error uploading image: $error');
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'profilePicture': imageUrl});
    } catch (error) {
      print('Error uploading profile picture: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
                    onTap: _pickImage,
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
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),
                            image: userData['profilePicture'] != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                        userData['profilePicture']),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage('assets/profile.png'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Change Profile Picture',
                              style: GoogleFonts.afacad(
                                textStyle: const TextStyle(
                                  color: secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  width: screenSize.width,
                  child: Column(
                    children: [
                      UserInfoTile(
                        margin: const EdgeInsets.only(bottom: 16),
                        label: 'Email',
                        value: userData['email'] ?? 'No Email Provided',
                      ),
                      UserInfoTile(
                        margin: const EdgeInsets.only(bottom: 16),
                        label: 'Full Name',
                        value: userData['name'] ?? 'No Name Provided',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueBackground;
  final EdgeInsetsGeometry? margin;

  const UserInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.margin,
    this.valueBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
