import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

String? getImageForTitle(String title) {
  if (breakfast.containsKey(title)) {
    return breakfast[title];
  } else if (lunch.containsKey(title)) {
    return lunch[title];
  } else if (dinner.containsKey(title)) {
    return dinner[title];
  }
  return null;
}

Future<void> addToShoppingList(
    String itemName, String quantity, String userId) async {
  final shoppingListRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('shoppingLists')
      .doc('lists');
  await shoppingListRef.update({
    'ingredients': FieldValue.arrayUnion([
      {'item_name': itemName, 'quantity': quantity}
    ]),
  });
}
