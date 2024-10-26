import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/screens/favorite_screen.dart';
import 'package:recipe_app_flutter/screens/my_app_home_screen.dart';
import 'package:recipe_app_flutter/screens/profile_screen.dart';
import 'package:recipe_app_flutter/screens/search_screen.dart';
import 'package:recipe_app_flutter/utils/constants.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  FirebaseAuth auth = FirebaseAuth.instance;
  String? userId;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    userId = auth.currentUser?.uid;
    _pages = [
      const MyAppHomeScreen(),
      const SearchScreen(),
      const FavoriteScreen(),
      const Center(child: Text('Shopping List')),
      ProfileScreen(userId: userId ?? ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryColor,
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        iconSize: screenWidth < 400 ? 24 : 28,
        currentIndex: selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: screenWidth < 400 ? 10 : 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: screenWidth < 400 ? 10 : 14,
          fontWeight: FontWeight.w500,
        ),
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 1 ? Icons.search : Icons.search_outlined,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 2 ? Icons.favorite : Icons.favorite_border,
            ),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 3
                  ? Icons.shopping_basket
                  : Icons.shopping_basket_outlined,
            ),
            label: "Shopping List",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 4
                  ? Icons.account_circle
                  : Icons.account_circle_outlined,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
