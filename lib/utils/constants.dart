import 'package:flutter/material.dart';

const bgColor = Color(0xFFffe0c5);
const primaryColor = Color(0xFFffe0c5);
const secondaryColor = Color(0xFF894847);
const buttonColor = Color(0xFF6f1d1b);
const titleColor = Color(0xFF6f1d1b);

const Map<String, String> breakfast = {
  "Classic Avocado Toast": 'assets/Avocado Toast.png',
  "Easiest Belgian Waffle": 'assets/Easiest Belgian Waffle Recipe.png',
  "Mushroom And Spinach Omelette": 'assets/Mushroom And Spinach Omelette.png',
  "Fluffy Pancakes": 'assets/Fluffy Pancakes.png',
};

const Map<String, String> lunch = {
  "Classic Chicken Sandwiches": 'assets/Chicken sandwiches.png',
  "Creamy Tomato Pasta": 'assets/Creamy Tomato Pasta.png',
  "Classic Grilled Cheese Sandwich": 'assets/Grilled Cheese Sandwich.png',
  "Ground Beef & Grilled Chicken Sandwich":
      'assets/Ground Beef Grilled Cheese Sandwich.png',
};

const Map<String, String> dinner = {
  "Creamy Alfredo Sauce Pasta": 'assets/Alfredo Sauce Pasta.png',
  "Chicken Biryani": 'assets/Chicken Biryani.png',
  "Chicken Shawarma with Yogurt Garlic Sauce":
      'assets/Chicken Shawarma with Yogurt-Garlic Sauce.png',
  "Classic Beef Burger": 'assets/Beef Burger.png',
};

final Map<String, Map<String, String>> allImages = {
  'Breakfast': breakfast,
  'Lunch': lunch,
  'Dinner': dinner,
};
