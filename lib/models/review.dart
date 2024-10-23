class ReviewModel {
  String id; // Unique identifier for the review
  String userId; // The ID of the user who submitted the review
  String recipeId; // The ID of the recipe being reviewed
  double rating; // Rating value (e.g., 1 to 5 stars)
  String? reviewText; // Optional review text from the user

  ReviewModel({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.rating,
    this.reviewText,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      recipeId: map['recipeId'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewText: map['reviewText'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipeId': recipeId,
      'rating': rating,
      'reviewText': reviewText,
    };
  }
}
