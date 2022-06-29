import 'package:cloud_firestore/cloud_firestore.dart';

class GreatFood {
  String id;
  String foodName;
  String storeName;
  String imageUrl;
  DateTime dateAdded;

  GreatFood(
      {required this.id,
      required this.foodName,
      required this.storeName,
      required this.imageUrl,
      required this.dateAdded});

  GreatFood.fromMap(Map<String, dynamic> snapshot, this.id)
      : foodName = snapshot['foodName'] ?? '',
        storeName = snapshot['storeName'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        dateAdded =
            (snapshot['dateAdded'] ?? Timestamp.now() as Timestamp).toDate();
}
