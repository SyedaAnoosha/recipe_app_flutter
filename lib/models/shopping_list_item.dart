class ShoppingListItem {
  String id;
  String userId;
  String? recipeId;
  List<String> items;
  bool isCompleted;

  ShoppingListItem({
    required this.id,
    required this.userId,
    this.recipeId,
    required this.items,
    this.isCompleted = false,
  });

  factory ShoppingListItem.fromMap(Map<String, dynamic> map) {
    return ShoppingListItem(
      id: map['id'] as String,
      userId: map['userId'] as String,
      recipeId: map['recipeId'] as String?,
      items: List<String>.from(map['items'] as List<dynamic>),
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipeId': recipeId,
      'items': items,
      'isCompleted': isCompleted,
    };
  }

  void markAsCompleted() {
    isCompleted = true;
  }

  void unmarkAsCompleted() {
    isCompleted = false;
  }
}
