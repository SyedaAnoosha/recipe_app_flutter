import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_flutter/screens/recipe_detail_screen.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'package:recipe_app_flutter/utils/favorite_icon.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String category = "All";
  double _minServings = 0;

  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("categories");

  Query get filteredRecipes => FirebaseFirestore.instance
      .collection("recipes")
      .where('category', arrayContains: category);

  Query get allRecipes => FirebaseFirestore.instance.collection("recipes");

  Query get selectedRecipes => category == "All" ? allRecipes : filteredRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          'Search Recipe',
          style: GoogleFonts.afacad(
            textStyle: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 30, color: primaryColor),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by title or a left over ingredient",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder(
              stream: categoriesItems.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('Error loading categories');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No categories found');
                }

                final categories = snapshot.data!.docs;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((categoryDoc) {
                      final categoryName = categoryDoc['category'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(categoryName),
                          selected: category == categoryName,
                          onSelected: (bool selected) {
                            setState(() {
                              category = selected ? categoryName : 'All';
                            });
                          },
                          selectedColor: buttonColor,
                          backgroundColor: Colors.white70,
                          labelStyle: TextStyle(
                            color: category == categoryName
                                ? primaryColor
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recipe Servings Scaler",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("${_minServings.toInt()} Servings"),
              ],
            ),
            Slider(
              value: _minServings,
              min: 0,
              max: 10,
              divisions: 10,
              label: _minServings.round().toString(),
              onChanged: (value) {
                setState(() {
                  _minServings = value;
                });
              },
              activeColor: buttonColor,
              inactiveColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: selectedRecipes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching recipes'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No recipes found'));
                  }

                  final recipes = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      final image = getImageForTitle(recipe['title']);
                      if (_searchQuery.isNotEmpty &&
                          !recipe['title']
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) &&
                          !recipe['ingredients']
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }

                      if (recipe['servings'] < _minServings) {
                        return const SizedBox.shrink();
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: image != null
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
                          ),
                          title: Text(
                            recipe['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text("${recipe['servings']} Servings  •  "),
                              Text("${recipe['time']} mins"),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  documentSnapshot: recipe,
                                  image: image ?? 'my_logo.png',
                                ),
                              ),
                            );
                          },
                          trailing: FavoriteIcon(documentSnapshot: recipe),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
