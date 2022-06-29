import 'package:flutter/material.dart';

import '../models/great_food.dart';
import '../services/firestore_service.dart';

class FoodGridView extends StatefulWidget {

  @override
  State<FoodGridView> createState() => _FoodGridViewState();
}

class _FoodGridViewState extends State<FoodGridView> {
  FirestoreService fsService = FirestoreService();

  @override Widget build(BuildContext context) {
    return StreamBuilder<List<GreatFood>>(
        stream: fsService.getAllGreatFood(), builder: (ctx, snapshot) =>
    snapshot.connectionState == ConnectionState.waiting ? Center(
        child: CircularProgressIndicator()) : !snapshot.hasData
        ? Center()
        : GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2), itemBuilder: (ctx, i) {
      return Padding(
        padding: const EdgeInsets.all(5), child: Stack(children: [ ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Image.network(snapshot.data![i].imageUrl, height: 150,
          width: double.infinity,
          fit: BoxFit.cover,),), Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)), color: Theme
            .of(context)
            .colorScheme
            .primary,),
        margin: EdgeInsets.only(top: 120),
        child: Column(children: [
          SizedBox(height: 5),
          Text(snapshot.data![i].storeName, style: TextStyle(
              color: Colors.white)),
          SizedBox(height: 2),
          Text(snapshot.data![i].foodName)
        ],),),
      ],),);
    }, itemCount: snapshot.data!.length,));
  }
}
