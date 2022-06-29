import 'package:flutter/material.dart';
import 'package:flutter_mini_project_4/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  static String routeName = '/edit-expense';

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  var form = GlobalKey<FormState>();


  String? purpose;

  String? mode;

  double? cost;

  DateTime? travelDate;

  void presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        travelDate = value;
      });
    });
    print(travelDate);
  }

  void saveForm(String id) {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      if (travelDate == null) travelDate = DateTime.now();

      print(purpose);
      print(mode);
      print(cost!.toStringAsFixed(2));

      FirestoreService fsService = FirestoreService();
      fsService.editExpense(id, purpose, mode, cost, travelDate);

      FocusScope.of(context).unfocus();

      form.currentState!.reset();
      travelDate = null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Travel expense added successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Expense selectedExpense =
        ModalRoute.of(context)?.settings.arguments as Expense;
    travelDate = selectedExpense.travelDate;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
        actions: [
          IconButton(
              onPressed: () {
                saveForm(selectedExpense.id);
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: form, //assigning the form to the key
          child: Column(
            children: [
              DropdownButtonFormField(
                value: selectedExpense.mode,
                onSaved: (value){ mode = value as String; },
                items: [
                  DropdownMenuItem(
                    child: Text("Bus"),
                    value: 'bus',
                  ),
                  DropdownMenuItem(
                    child: Text("Grab"),
                    value: 'grab',
                  ),
                  DropdownMenuItem(
                    child: Text("MRT"),
                    value: 'mrt',
                  ),
                  DropdownMenuItem(
                    child: Text("Taxi"),
                    value: 'taxi',
                  ),
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please enter a Mode of Transport";
                  } else
                    return null;
                },
                onChanged: (value) {
                  mode = value as String;
                },
                decoration: InputDecoration(label: Text("Mode of Transport")),
              ),
              TextFormField(
                initialValue: selectedExpense.cost.toStringAsFixed(2),
                decoration: InputDecoration(label: Text("Cost")),
                onSaved: (value) {
                  cost = double.parse(value!);
                },
                validator: (value) {
                  if (value == null) {
                    return "Please provide a travel cost.";
                  } else if (double.tryParse(value) == null) {
                    return "Please provide a valid travel cost.";
                  } else
                    return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                initialValue: selectedExpense.purpose,
                decoration: InputDecoration(label: Text("Purpose")),
                validator: (value) {
                  if (value == null) {
                    return "Please enter a purpose to the expense";
                  }
                  if (value.length < 5) {
                    return "Please include a purpose longer than 5 letters long";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  purpose = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(travelDate == null
                      ? "No date Chosen"
                      : DateFormat('dd/MM/yyyy').format(travelDate!)),
                  TextButton(
                    onPressed: () {
                      presentDatePicker(context);
                    },
                    child: Text("Choose Date"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
