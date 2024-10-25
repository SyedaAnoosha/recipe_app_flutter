import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'package:recipe_app_flutter/provider/favorite_provider.dart';

class FavoriteIcon extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const FavoriteIcon({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white70,
      child: InkWell(
        onTap: () {
          provider.toggleFavorite(documentSnapshot);
        },
        child: Icon(
          provider.isExist(documentSnapshot)
              ? Icons.favorite
              : Icons.favorite_border_outlined,
          color:
              provider.isExist(documentSnapshot) ? buttonColor : secondaryColor,
          size: 20,
        ),
      ),
    );
  }
}
