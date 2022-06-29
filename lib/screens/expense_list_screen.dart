import 'package:flutter/material.dart';
import 'package:flutter_mini_project_4/models/expense.dart';
import 'package:flutter_mini_project_4/services/firestore_service.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/expenses_list.dart';
import 'add_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  static String routeName = '/expense-list';

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    FirestoreService fsService = FirestoreService();


    return StreamBuilder<List<Expense>>(
      stream: fsService.getExpenses(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting ?
        Center(child: CircularProgressIndicator(),) :
          Scaffold(
            appBar: AppBar(
              title: Text('My Expenses'),
            ),
            body: Container(
                alignment: Alignment.center,
                child: snapshot.data!.length > 0
                    ? ExpensesList()
                    : Column(
                        children: [
                          SizedBox(height: 20),
                          Image.asset('images/empty.png', width: 300),
                          Text('No expenses yet, add a new one today!',
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      )),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddExpenseScreen.routeName);
                },
                child: Icon(Icons.add)),
            drawer: AppDrawer());
      }
    );
  }
}
