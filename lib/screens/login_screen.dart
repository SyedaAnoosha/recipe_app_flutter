import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/signup_screen.dart';
import 'package:recipe_app_flutter/utils/auth_service.dart';
import 'package:recipe_app_flutter/utils/bottom_bar.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  AuthService auth = AuthService();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Welcome back to Cook Smart',
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
                    final email = emailC.text.trim();
                    final password = passC.text.trim();

                    if (email.isNotEmpty && password.isNotEmpty) {
                      try {
                        final user = await auth.signIn(email, password);
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomBar(),
                            ),
                          );
                        } else {
                          setState(() {
                            errorMessage =
                                'Oops! You are a new user. Please sign up.';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          errorMessage = e.toString();
                        });
                      }
                    } else {
                      setState(() {
                        errorMessage = 'Please fill in both fields.';
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
                    'Log In',
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: buttonColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
