import 'package:flutter/material.dart';

import '../screens/expenses_screen.dart';
import '../screens/budget_screen.dart';
import '../screens/shopping_screen.dart';
import '../screens/history_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 90,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Colors.deepPurple,
            // child: Text(
            //   'Planner',
            //   style: TextStyle(
            //     fontWeight: FontWeight.w900,
            //     fontSize: 30,
            //     color: Colors.white,
            //   ),
            // ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.monetization_on,
              size: 26,
            ),
            title: Text(
              'Expenses',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => ExpensesScreen(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_balance_wallet,
              size: 26,
            ),
            title: Text(
              'Budget',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => BudgetScreen(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              size: 26,
            ),
            title: Text(
              'Shopping List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => ShoppingScreen(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              size: 26,
            ),
            title: Text(
              'History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => HistoryScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
