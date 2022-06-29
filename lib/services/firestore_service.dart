import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mini_project_4/services/auth_service.dart';

import '../models/expense.dart';
import '../models/great_food.dart';

class FirestoreService {
  AuthService authService = AuthService();

  addExpense(purpose, mode, cost, travelDate) {
    return FirebaseFirestore.instance.collection('expenses').add({
      'email': authService.getCurrentUser()!.email,
      'purpose': purpose,
      'mode': mode,
      'cost': cost,
      'travelDate': travelDate
    });
  }

  removeExpense(id) {
    return FirebaseFirestore.instance.collection('expenses').doc(id).delete();
  }

  Stream<List<Expense>> getExpenses() {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where('email', isEqualTo: authService.getCurrentUser()!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<Expense>((doc) => Expense.fromMap(doc.data(), doc.id))
            .toList());
  }

  editExpense(id, purpose, mode, cost, travelDate) {
    return FirebaseFirestore.instance.collection('expenses').doc(id).set({
      'purpose': purpose,
      'mode': mode,
      'cost': cost,
      'travelDate': travelDate
    });
  }

  addGreatFood(foodName, storeName, imageUrl) {
    return FirebaseFirestore.instance.collection('great-food').add({
      'foodName': foodName,
      'storeName': storeName,
      'imageUrl': imageUrl,
      'dateAdded': DateTime.now()
    });
  }

  Stream<List<GreatFood>> getAllGreatFood() {
    return FirebaseFirestore.instance
        .collection('great-food')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => GreatFood.fromMap(doc.data(), doc.id))
            .toList());
  }
}
