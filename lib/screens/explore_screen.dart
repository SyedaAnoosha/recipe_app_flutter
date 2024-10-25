import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/utils/view_all_items.dart';

class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ViewAllItems(),
      ),
    );
  }
}
