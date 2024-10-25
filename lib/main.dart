import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_flutter/screens/profile_screen.dart';
import 'package:recipe_app_flutter/screens/welcome_screen.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'package:recipe_app_flutter/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_flutter/provider/favorite_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (_) => FavoriteProvider(), child: const RecipeApp()));
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
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
