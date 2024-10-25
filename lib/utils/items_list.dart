import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/recipe_detail_screen.dart';
import 'package:recipe_app_flutter/utils/constants.dart';
import 'package:recipe_app_flutter/utils/favorite_icon.dart';

SingleChildScrollView items_list_view() {
  final CollectionReference documentSnapshot =
      FirebaseFirestore.instance.collection("recipes");
  return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, right: 5),
      child: Column(
        children: [
          const SizedBox(height: 10),
          StreamBuilder(
            stream: documentSnapshot.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    final String? image =
                        getImageForTitle(documentSnapshot['title']);

                    return ListTile(
                      leading: image != null
                          ? Image.asset(
                              image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: secondaryColor,
                            ),
                      title: Text(
                        documentSnapshot['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(
                            Icons.restaurant_rounded,
                            size: 16,
                            color: secondaryColor,
                          ),
                          Text(
                            "${documentSnapshot['servings']} Servings",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.timer,
                            size: 16,
                            color: secondaryColor,
                          ),
                          Text(
                            "${documentSnapshot['time']} Min",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      trailing:
                          FavoriteIcon(documentSnapshot: documentSnapshot),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(
                                documentSnapshot: documentSnapshot,
                                image: image ?? 'my_logo.png'),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ));
}
