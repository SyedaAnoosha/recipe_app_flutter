import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'package:recipe_app_flutter/screens/login_screen.dart';
import 'package:recipe_app_flutter/screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double buttonPadding = screenWidth < 480 ? 20.0 : 45.0;
    double buttonFontSize = screenWidth < 480 ? 14.0 : 18.0;

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
            child: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/my_logo.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPadding,
                        vertical: 20,
                      ),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.afacad(
                        textStyle: TextStyle(
                            fontSize: buttonFontSize, color: primaryColor),
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
    ));
  }
}
