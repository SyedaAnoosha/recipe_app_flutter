import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProvider extends ChangeNotifier {
  final String userId;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  List<String> _favorites = [];

  FavoriteProvider({required this.userId}) {
    _loadFavorites();
  }

  List<String> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    DocumentSnapshot userDoc = await userCollection.doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      _favorites = List<String>.from(data['favorites'] ?? []);
      notifyListeners();
    }
  }

  Future<void> addFavorite(String recipeId) async {
    if (!_favorites.contains(recipeId)) {
      _favorites.add(recipeId);
      await updateFavoritesInFirestore();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String recipeId) async {
    if (_favorites.contains(recipeId)) {
      _favorites.remove(recipeId);
      await updateFavoritesInFirestore();
      notifyListeners();
    }
  }

  Future<void> updateFavoritesInFirestore() async {
    await userCollection.doc(userId).update(
      {'favorites': _favorites},
    );
  }

  bool isFavorite(String recipeId) {
    return _favorites.contains(recipeId);
  }
}
