import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_flutter/utils/common_methods.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

class ShoppingListScreen extends StatefulWidget {
  final String userId;

  const ShoppingListScreen({super.key, required this.userId});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          'My Shopping Lists',
          style: GoogleFonts.afacad(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
              color: primaryColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('shoppingLists')
            .doc('lists')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No items in your shopping list."));
          }

          var ingredients = snapshot.data!['ingredients'] as List<dynamic>;

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return ListTile(
                title: Text(ingredient['item_name']),
                subtitle: Text("Quantity: ${ingredient['quantity']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: secondaryColor),
                  onPressed: () => _removeItem(ingredient),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(),
        backgroundColor: secondaryColor,
        child: const Icon(Icons.add_shopping_cart, color: primaryColor),
      ),
    );
  }

  void _removeItem(Map<String, dynamic> ingredient) async {
    final shoppingListRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('shoppingLists')
        .doc('lists');

    await shoppingListRef.update({
      'ingredients': FieldValue.arrayRemove([ingredient]),
    });
  }

  void _showAddItemDialog() {
    TextEditingController itemController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Item to Shopping List"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemController,
                decoration: const InputDecoration(labelText: "Item Name"),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final itemName = itemController.text;
                final quantity = quantityController.text;

                if (itemName.isNotEmpty && quantity.isNotEmpty) {
                  addToShoppingList(itemName, quantity, widget.userId);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
