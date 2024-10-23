import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId; // Recipe ID passed from the previous page

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool showIngredients = true;
  DocumentSnapshot? recipeData;

  @override
  void initState() {
    super.initState();
    fetchRecipeData();
  }

  Future<void> fetchRecipeData() async {
    final doc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .get();

    setState(() {
      recipeData = doc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
      ),
      body: recipeData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Image
                    Hero(
                      tag: recipeData?['image'],
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              recipeData?['image'],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Category
                    Text(
                      (recipeData?['category'].length > 1)
                          ? recipeData!['category'].join(", ")
                          : recipeData?['category'][0] ?? 'Uncategorized',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title and Basic Info (Servings, Time, Level)
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
                        _infoColumn('Servings',
                            recipeData?['servings'].toString() ?? '0pp'),
                        _infoColumn('Prep Time', '${recipeData?['time']}m'),
                        _infoColumn('Level', recipeData?['level'] ?? ''),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      recipeData?['description'] ?? '',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),

                    // Toggle between Ingredients and Directions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _tabButton('Ingredients', showIngredients),
                        const SizedBox(width: 16),
                        _tabButton('Directions', !showIngredients),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Ingredients or Directions
                    showIngredients
                        ? _buildIngredientsList(recipeData?['ingredients'])
                        : _buildInstructionsList(recipeData?['instructions']),
                  ],
                ),
              ),
            ),
    );
  }

  // Column widget for displaying Servings, Time, and Difficulty
  Widget _infoColumn(String label, String value) {
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

  // Tab button for switching between Ingredients and Directions
  Widget _tabButton(String text, bool isActive) {
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

  // Ingredients List
  Widget _buildIngredientsList(List<dynamic> ingredients) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

  // Instructions List
  Widget _buildInstructionsList(List<dynamic> instructions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
}
