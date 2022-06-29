import 'package:flutter/material.dart';

import '../widgets/add_great_food_form.dart';
import '../widgets/app_drawer.dart';
import '../widgets/food_gridview.dart';

class FoodScreen extends StatelessWidget {
  static String routeName = "/food";

  addGreatFood(context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddGreatFoodForm();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Food Screen'),
        actions: [
          IconButton(
              onPressed: () => addGreatFood(context), icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(padding: EdgeInsets.all(20), child: FoodGridView()),
      ),
    );
  }
}
