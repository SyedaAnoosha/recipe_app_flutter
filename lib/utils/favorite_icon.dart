// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:recipe_app_flutter/utils/constants.dart';
// import 'package:recipe_app_flutter/provider/favorite_provider.dart';

// class FavoriteIcon extends StatelessWidget {
//   final DocumentSnapshot<Object?> documentSnapshot;

//   const FavoriteIcon({super.key, required this.documentSnapshot});

//   @override
//   Widget build(BuildContext context) {
//     final provider = FavoriteProvider.of(context);

//     return CircleAvatar(
//       backgroundColor: Colors.white70,
//       child: GestureDetector(
//         onTap: () {
//           provider.toggleFavorite(documentSnapshot);
//         },
//         child: Icon(
//           provider.isExist(documentSnapshot)
//               ? Icons.favorite
//               : Icons.favorite_border_outlined,
//           color:
//               provider.isExist(documentSnapshot) ? buttonColor : secondaryColor,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_flutter/provider/favorite_provider.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
// import 'package:recipe_app_flutter/provider/favorite_provider.dart';

class FavoriteIcon extends StatelessWidget {
  final DocumentSnapshot recipe;

  const FavoriteIcon({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return IconButton(
      icon: Icon(
        favoriteProvider.isFavorite(recipe.id)
            ? Icons.favorite
            : Icons.favorite_border,
        color: favoriteProvider.isFavorite(recipe.id)
            ? secondaryColor
            : secondaryColor.withOpacity(0.5),
      ),
      onPressed: () {
        if (favoriteProvider.isFavorite(recipe.id)) {
          favoriteProvider.removeFavorite(recipe.id);
        } else {
          favoriteProvider.addFavorite(recipe.id);
        }
      },
    );
  }
}
