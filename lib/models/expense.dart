import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String email;
  String purpose;
  String mode;
  double cost;
  DateTime travelDate;
  Expense(
      {
        required this.id,
        required this.email,
      required this.purpose,
      required this.mode,
      required this.cost,
      required this.travelDate});

  Expense.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id,
        email =  snapshot['email'] ?? '',
      purpose = snapshot['purpose'] ?? '',
        mode = snapshot['mode'] ?? '',
        cost = snapshot['cost'] ?? '',
        travelDate =
            (snapshot['travelDate'] ?? Timestamp.now() as Timestamp).toDate();
}
