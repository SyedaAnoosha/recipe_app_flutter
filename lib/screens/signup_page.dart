import 'package:flutter/material.dart';
// import 'package:recipe_app_flutter/screens/home_page.dart';
import 'package:recipe_app_flutter/screens/login_page.dart';
import 'package:recipe_app_flutter/screens/recipe_detail.dart';
import 'package:recipe_app_flutter/utils/auth_service.dart';

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
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/my_logo.png',
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 20),
              const Text(
                "Let's start making good meals",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Display error message if any
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              // Name Field
              SizedBox(
                width: 350,
                child: TextField(
                  controller: nameC,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Email Field
              SizedBox(
                width: 350,
                child: TextField(
                  controller: emailC,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Password Field
              SizedBox(
                width: 350,
                child: TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
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
                      // Sign up the user using AuthService
                      final user = await _authService.signUp(email, password);

                      if (user != null) {
                        // On successful signup, navigate to HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecipeDetailPage(
                                recipeId: "e7zILwtXuT1shihsFbtQ"),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16),
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
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
