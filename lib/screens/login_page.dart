import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/recipe_detail.dart';
import 'package:recipe_app_flutter/screens/signup_page.dart';
import 'package:recipe_app_flutter/utils/auth_service.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/my_logo.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome back to Cook Smart',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),

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
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Login Button
              ElevatedButton(
                onPressed: () async {
                  final email = emailC.text.trim();
                  final password = passC.text.trim();

                  print('Login pressed: $email, $password');

                  if (email.isNotEmpty && password.isNotEmpty) {
                    try {
                      await auth.signIn(email, password);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecipeDetailPage(
                              recipeId: "e7zILwtXuT1shihsFbtQ"),
                        ),
                      );
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // Background color
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              // Go to Signup Page Link
              TextButton(
                onPressed: () {
                  // Navigate to Signup Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
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
