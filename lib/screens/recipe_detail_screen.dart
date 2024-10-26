import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_flutter/utils/commonMethods.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String image;
  const RecipeDetailScreen(
      {super.key, required this.documentSnapshot, required this.image});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool showIngredients = true;
  DocumentSnapshot? recipeData;
  String? image_title;
  String? userId;

  @override
  void initState() {
    super.initState();
    recipeData = widget.documentSnapshot;
    image_title = widget.image;
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          recipeData?['title'] ?? '',
          style: GoogleFonts.afacad(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
              color: primaryColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: recipeData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(image_title ?? ''),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      (recipeData?['category'] != null &&
                              recipeData!['category'].length > 1)
                          ? recipeData!['category'].join(", ")
                          : recipeData?['category'][0] ?? 'Uncategorized',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipeData?['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        recipeInfo('Servings',
                            recipeData?['servings'].toString() ?? '0'),
                        recipeInfo('Prep Time', '${recipeData?['time']}m'),
                        recipeInfo('Level', recipeData?['level'] ?? ''),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      recipeData?['description'] ?? '',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tabButton('Ingredients', showIngredients),
                        const SizedBox(width: 16),
                        tabButton('Directions', !showIngredients),
                      ],
                    ),
                    const SizedBox(height: 16),
                    showIngredients
                        ? ingredientsList(recipeData?['ingredients'])
                        : directionsList(recipeData?['directions']),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addToListDialog(),
        backgroundColor: secondaryColor,
        child: const Icon(Icons.add_shopping_cart, color: primaryColor),
      ),
    );
  }

  Widget recipeInfo(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(
              fontSize: 16,
              color: secondaryColor,
            )),
      ],
    );
  }

  Widget tabButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showIngredients = text == 'Ingredients';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          color: isActive ? buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isActive ? 20 : 18,
            color: isActive ? primaryColor : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget ingredientsList(List<dynamic>? ingredients) {
    if (ingredients == null) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '- ${ingredients[index]}',
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        );
      },
    );
  }

  Widget directionsList(List<dynamic>? instructions) {
    if (instructions == null) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: instructions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${index + 1}. ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  instructions[index],
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addToListDialog() {
    TextEditingController itemController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add to Shopping List"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemController,
                decoration: const InputDecoration(labelText: "Item Name"),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final itemName = itemController.text.isNotEmpty
                    ? itemController.text
                    : recipeData?['title'];
                final quantity = quantityController.text;

                if (userId != null && itemName != null && quantity.isNotEmpty) {
                  addToShoppingList(itemName, quantity, userId!);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
