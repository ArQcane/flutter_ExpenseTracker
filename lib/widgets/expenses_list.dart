import 'package:flutter/material.dart';
import 'package:flutter_mini_project_4/services/firestore_service.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../screens/edit_expense_screen.dart';

class ExpensesList extends StatefulWidget {
  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  FirestoreService fsService = FirestoreService();

  void removeItem(String id) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      fsService.removeExpense(id);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
        stream: fsService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView.separated(
                itemBuilder: (ctx, i) {
                  return ListTile(
                      title: Text(snapshot.data![i].purpose),
                      leading: CircleAvatar(
                        child: Text(snapshot.data![i].mode),
                      ),
                      subtitle: Text(snapshot.data![i].cost.toStringAsFixed(2)),
                      trailing: IconButton(
                        onPressed: () => removeItem(snapshot.data![i].id),
                        icon: Icon(Icons.delete),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, EditExpenseScreen.routeName,
                          arguments: snapshot.data![i]));
                },
                separatorBuilder: (ctx, i) {
                  return Divider(
                      height: 3,
                      color: i % 2 == 0 ? Colors.blueGrey : Colors.green);
                },
                itemCount: snapshot.data!.length);
          }
        });
  }
}
