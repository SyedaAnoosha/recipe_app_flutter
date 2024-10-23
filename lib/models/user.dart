// user_model.dart

import 'package:recipe_app_flutter/models/favorite.dart';
import 'package:recipe_app_flutter/models/shopping_list_item.dart';

class UserModel {
  String id;
  String name;
  String email;
  String? profileImage;
  List<Favorite> favorites;
  List<ShoppingListItem> shoppingList;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.favorites,
    required this.shoppingList,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String?,
      favorites: (map['favorites'] as List<dynamic>)
          .map((item) => Favorite.fromMap(item as Map<String, dynamic>))
          .toList(),
      shoppingList: (map['shoppingList'] as List<dynamic>)
          .map((item) => ShoppingListItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'favorites': favorites,
      'shoppingList': shoppingList,
    };
  }

  void addFavorite(Favorite favorite) {
    favorites.add(favorite);
  }

  void removeFavorite(Favorite favorite) {
    favorites.remove(favorite);
  }

  void addToShoppingList(ShoppingListItem item) {
    shoppingList.add(item);
  }

  void removeFromShoppingList(ShoppingListItem item) {
    shoppingList.remove(item);
  }
}
