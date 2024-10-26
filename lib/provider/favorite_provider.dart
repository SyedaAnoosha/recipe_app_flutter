import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProvider extends ChangeNotifier {
  final String userId;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  List<String> _favorites = [];

  FavoriteProvider({required this.userId}) {
    _loadFavorites();
  }

  List<String> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    DocumentSnapshot userDoc = await _userCollection.doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      _favorites = List<String>.from(data['favorites'] ?? []);
      notifyListeners();
    }
  }

  Future<void> addFavorite(String recipeId) async {
    if (!_favorites.contains(recipeId)) {
      _favorites.add(recipeId);
      await _updateFavoritesInFirestore();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String recipeId) async {
    if (_favorites.contains(recipeId)) {
      _favorites.remove(recipeId);
      await _updateFavoritesInFirestore();
      notifyListeners();
    }
  }

  Future<void> _updateFavoritesInFirestore() async {
    await _userCollection.doc(userId).set(
      {'favorites': _favorites},
      SetOptions(merge: true),
    );
  }

  bool isFavorite(String recipeId) {
    return _favorites.contains(recipeId);
  }
}
