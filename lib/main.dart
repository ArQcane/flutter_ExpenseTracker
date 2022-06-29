import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_project_4/screens/add_expense_screen.dart';
import 'package:flutter_mini_project_4/screens/auth_screen.dart';
import 'package:flutter_mini_project_4/screens/edit_expense_screen.dart';
import 'package:flutter_mini_project_4/screens/expense_list_screen.dart';
import 'package:flutter_mini_project_4/screens/food_screen.dart';
import 'package:flutter_mini_project_4/services/auth_service.dart';
import 'package:flutter_mini_project_4/services/firestore_service.dart';
import 'package:flutter_mini_project_4/widgets/app_drawer.dart';

import 'models/expense.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder<User?>(
                  stream: authService.getAuthUser(),
                  builder: (context, snapshot) {
                    return MaterialApp(
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                      ),
                      home: snapshot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : snapshot.hasData
                              ? MainScreen()
                              : AuthScreen(),
                      routes: {
                        AddExpenseScreen.routeName: (_) {
                          return AddExpenseScreen();
                        },
                        ExpenseListScreen.routeName: (_) {
                          return ExpenseListScreen();
                        },
                        EditExpenseScreen.routeName: (_) {
                          return EditExpenseScreen();
                        },
                        AuthScreen.routeName: (_) {
                          return AuthScreen();
                        },
                        FoodScreen.routeName: (_){
                          return FoodScreen();
                        }
                      },
                    );
                  }),
    );
  }
}

class MainScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    FirestoreService fsService = FirestoreService();
    AuthService authService = AuthService();
    logOut() {
      return authService.logOut().then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Logout successfully!'),
        ));
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }

    return StreamBuilder<List<Expense>>(
        stream: fsService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            double sum = 0;
            snapshot.data!.forEach((doc) {
              sum += doc.cost;
            });
            return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text('Expense Tracker'),
                  actions: [
                    IconButton(
                        onPressed: () => logOut(), icon: Icon(Icons.logout))
                  ],
                ),
                body: Column(
                  children: [
                    Image.asset('images/creditcard.png'),
                    Text('Total spent: \$' + sum.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.titleLarge)
                  ],
                ),
                drawer: AppDrawer());
          }
        });
  }
}
