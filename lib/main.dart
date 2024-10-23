import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'package:recipe_app_flutter/firebase_options.dart';
import 'package:recipe_app_flutter/screens/login_page.dart';
// import 'package:recipe_app_flutter/screens/recipe_detail.dart';
import 'package:recipe_app_flutter/screens/signup_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook Smart',
      theme: ThemeData(
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.afacadTextTheme(),
        scaffoldBackgroundColor: bgColor,
      ),
      // home: const RecipeDetailPage(recipeId: "e7zILwtXuT1shihsFbtQ"),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg-image-new.jpeg'),
                opacity: 0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              // height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text(
                  //   'Cook Smart',
                  //   style: GoogleFonts.afacad(
                  //     textStyle: const TextStyle(
                  //       fontSize: 28,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  Text(
                      'Nutritionally balanced, easy to cook recipes. Quality fresh local ingredients.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.afacad(
                        textStyle: const TextStyle(
                            fontSize: 18.0, color: secondaryColor),
                      )),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 45, vertical: 20),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.afacad(
                        textStyle:
                            const TextStyle(fontSize: 18, color: primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: GoogleFonts.afacad(
                          textStyle:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Log In',
                            style: GoogleFonts.afacad(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: buttonColor,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
