import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_flutter/screens/explore_screen.dart';
import 'package:recipe_app_flutter/screens/recipe_detail_screen.dart';
import 'package:recipe_app_flutter/screens/search_screen.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String category = "All";
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("categories");

  Query get filteredRecipes => FirebaseFirestore.instance
      .collection("recipes")
      .where('category', arrayContains: category);

  Query get allRecipes => FirebaseFirestore.instance.collection("recipes");

  Query get selectedRecipes => category == "All" ? allRecipes : filteredRecipes;

  Query get featuredRecipes => FirebaseFirestore.instance
      .collection('recipes')
      .where('featured', isEqualTo: true);

  Query get recentlyViewedRecipes => FirebaseFirestore.instance
      .collection('recently_viewed')
      .orderBy('timestamp', descending: true)
      .limit(5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Cook Smart",
          style: GoogleFonts.afacad(
            textStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 32, color: primaryColor),
          ),
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hello, What do you want to cook today?",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width >= 600
                                ? 30
                                : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SearchBar(),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                    selectedCategory(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Explore Recipes",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExploreScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "View all",
                            style: TextStyle(
                              color: buttonColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: selectedRecipes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final exploreRecipes = snapshot.data?.docs ?? [];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: _buildHorizontalRecipeList(exploreRecipes),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Featured Recipes",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder(
                stream: featuredRecipes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final featured = snapshot.data?.docs ?? [];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: _buildHorizontalRecipeList(featured),
                  );
                },
              ),
              const SizedBox(height: 20),
              // const Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Text(
              //     "Recently Viewed",
              //     style: TextStyle(
              //       fontSize: 20,
              //       letterSpacing: 0.1,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // StreamBuilder(
              //   stream: recentlyViewedRecipes.snapshots(),
              //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (!snapshot.hasData) {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //     final recentlyViewed = snapshot.data?.docs ?? [];
              //     return Padding(
              //       padding: const EdgeInsets.only(top: 5, left: 15),
              //       child: _buildHorizontalRecipeList(recentlyViewed),
              //     );
              //   },
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalRecipeList(List<DocumentSnapshot> recipes) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final image = getImageForTitle(recipe['title']);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(
                    documentSnapshot: recipe,
                    image: image,
                  ),
                ),
              );
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      image: DecorationImage(
                        image: AssetImage(image!), // Adjust image logic
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      recipe['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.restaurant_rounded,
                          size: 16,
                          color: secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${recipe['servings']} Servings",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]['category'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: category ==
                              streamSnapshot.data!.docs[index]['category']
                          ? buttonColor
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]['category'],
                      style: TextStyle(
                        color: category ==
                                streamSnapshot.data!.docs[index]['category']
                            ? Colors.white
                            : secondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Padding SearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search),
            fillColor: Colors.white70,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: "Search any recipe",
            hintStyle: const TextStyle(
              color: secondaryColor,
            ),
            contentPadding: const EdgeInsets.only(top: 10),
          ),
        ),
      ),
    );
  }
}
