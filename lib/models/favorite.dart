class Favorite {
  String userId;
  String recipeId;

  Favorite({
    required this.userId,
    required this.recipeId,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      userId: map['userId'] as String,
      recipeId: map['recipeId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'recipeId': recipeId,
    };
  }
}
