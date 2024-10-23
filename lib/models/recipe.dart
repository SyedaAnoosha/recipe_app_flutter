class Recipe {
  String id; // Unique Recipe ID
  String name;
  List<String> ingredients;
  String instructions;
  String imageUrl;
  int cookingTime; // In minutes
  int servings; // Number of servings

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.cookingTime,
    required this.servings,
  });

  // Convert a Recipe object into a Map to send to Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'cookingTime': cookingTime,
      'servings': servings,
    };
  }

  // Create a Recipe object from Firebase data
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      ingredients: List<String>.from(map['ingredients']),
      instructions: map['instructions'],
      imageUrl: map['imageUrl'],
      cookingTime: map['cookingTime'],
      servings: map['servings'],
    );
  }
}
