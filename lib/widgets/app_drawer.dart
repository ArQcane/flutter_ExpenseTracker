import 'package:flutter/material.dart';
import 'package:flutter_mini_project_4/screens/food_screen.dart';
import 'package:flutter_mini_project_4/services/auth_service.dart';

import '../main.dart';
import '../screens/expense_list_screen.dart';

class AppDrawer extends StatelessWidget {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: FittedBox(child: Text('Hello ' + authService.getCurrentUser()!.email! + '!')),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(MainScreen.routeName),
        ),
        Divider(height: 3, color: Colors.blueGrey),
        ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text('My Expenses'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(ExpenseListScreen.routeName),
        ),
        Divider(height: 3, color: Colors.blueGrey),
        ListTile(
          leading: Icon(Icons.wine_bar),
          title: Text('Great Food'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(FoodScreen.routeName),
        ),
        Divider(height: 3, color: Colors.blueGrey),
      ]),
    );
  }
}
