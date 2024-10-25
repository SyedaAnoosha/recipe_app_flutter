import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_flutter/screens/recipe_detail_screen.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'package:recipe_app_flutter/utils/favorite_icon.dart';
import 'package:recipe_app_flutter/provider/favorite_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteItems = provider.favorites;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          'My Favorites',
          style: GoogleFonts.afacad(
            textStyle: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 30, color: primaryColor),
          ),
        ),
        centerTitle: true,
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                "No Favorites yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                String favorite = favoriteItems[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("recipes")
                      .doc(favorite)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading favorite"),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(
                        child: Text("Recipe not found"),
                      );
                    }

                    var favoriteItem = snapshot.data!;
                    final String? image =
                        getImageForTitle(favoriteItem['title']);

                    return ListTile(
                      leading: image != null
                          ? Image.asset(
                              image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: secondaryColor,
                            ),
                      title: Text(
                        favoriteItem['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(
                            Icons.restaurant_rounded,
                            size: 16,
                            color: secondaryColor,
                          ),
                          Text(
                            "${favoriteItem['servings']} Servings",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.timer,
                            size: 16,
                            color: secondaryColor,
                          ),
                          Text(
                            "${favoriteItem['time']} Min",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      trailing: FavoriteIcon(documentSnapshot: favoriteItem),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(
                                documentSnapshot: favoriteItem,
                                image: image ?? 'my_logo.png'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
