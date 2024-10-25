import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    recipeData = widget.documentSnapshot;
    image_title = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeData?['title'] ?? '',
            style: const TextStyle(fontSize: 24, color: primaryColor)),
        backgroundColor: secondaryColor,
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
                        _infoColumn('Servings',
                            recipeData?['servings'].toString() ?? '0'),
                        _infoColumn('Prep Time', '${recipeData?['time']}m'),
                        _infoColumn('Level', recipeData?['level'] ?? ''),
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
                        _tabButton('Ingredients', showIngredients),
                        const SizedBox(width: 16),
                        _tabButton('Directions', !showIngredients),
                      ],
                    ),
                    const SizedBox(height: 16),
                    showIngredients
                        ? _buildIngredientsList(recipeData?['ingredients'])
                        : _buildInstructionsList(recipeData?['directions']),
                  ],
                ),
              ),
            ),
    );
  }

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

  Widget _buildIngredientsList(List<dynamic>? ingredients) {
    if (ingredients == null) return const SizedBox.shrink();
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

  Widget _buildInstructionsList(List<dynamic>? instructions) {
    if (instructions == null) return const SizedBox.shrink();
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
