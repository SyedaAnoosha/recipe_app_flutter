import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/login_screen.dart';
import 'package:recipe_app_flutter/utils/auth_service.dart';
import 'package:recipe_app_flutter/utils/bottom_bar.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_image_new.jpeg'),
                opacity: 0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/my_logo.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Let's start making good meals",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: titleColor),
                ),
                const SizedBox(height: 20),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: buttonColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: emailC,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: buttonColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: passC,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: buttonColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameC.text.trim();
                    final email = emailC.text.trim();
                    final password = passC.text.trim();
                    if (name.isNotEmpty &&
                        email.isNotEmpty &&
                        password.isNotEmpty) {
                      try {
                        final user = await _authService.signUp(email, password);

                        if (user != null) {
                          await _firestore
                              .collection('users')
                              .doc(user.uid)
                              .set({
                            'name': name,
                            'email': email,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomBar(),
                            ),
                          );
                        } else {
                          setState(() {
                            errorMessage = 'Sign up failed. Please try again.';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          errorMessage = e.toString();
                        });
                      }
                    } else {
                      setState(() {
                        errorMessage = 'Please fill in all fields.';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: const Text(
                    "Already have an account? Log In",
                    style: TextStyle(color: buttonColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
