import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../widgets/main_drawer.dart';
import '../widgets/budget_percent.dart';
import '../models/transaction.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final budgetFocusNode = FocusNode();
  var budgetTextController = TextEditingController();
  var show = false;
  int expense;
  Transaction costliestTransaction;
  SharedPreferences prefs;

  @override
  void initState() {
    //print("Init state");
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
      });
    });
    budgetFocusNode.addListener(updateBudget);
    super.initState();
  }

  @override
  void dispose() {
    budgetFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("dependencies");
    final p = Provider.of<Transactions>(context, listen: false);
    expense = p.totalExpense();
    costliestTransaction = p.costliestTransaction();
    super.didChangeDependencies();
  }

  void updateBudget() {
    if (!budgetFocusNode.hasFocus) {
      if (budgetTextController.text.isEmpty) {
        print("Empty");
        prefs.clear();
        setState(() {});
      } else {
        if (int.tryParse(budgetTextController.text) != null) {
          prefs.setString('budget', budgetTextController.text);
          print("budget set: ${budgetTextController.text}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please enter a valid budget value'),
            duration: Duration(seconds: 1),
          ));
          //budgetTextController.text = '0';
        }
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("In build");
    String budget;
    print("Prefs in build: " + prefs.toString());
    print("Prefs in build null check: " + (prefs == null).toString());
    if (prefs != null) {
      if (prefs.containsKey('budget')) {
        budget = prefs.getString('budget');
        budgetTextController.text = budget;
      } else {
        print("in here");
        budget = '0';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget'),
      ),
      drawer: MainDrawer(),
      body: prefs == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Budget Amount',
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                'Rs.',
                                style: TextStyle(fontSize: 18),
                              ),
                              AutoSizeTextField(
                                style: TextStyle(fontSize: 18),
                                keyboardType: TextInputType.number,
                                focusNode: budgetFocusNode,
                                textAlign: TextAlign.center,
                                controller: budgetTextController,
                                fullwidth: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Monthly Summary',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        BudgetPercent(int.parse(budget), expense),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Amount Spent:',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                Text(
                                  'Rs. $expense',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 30),
                          child: int.parse(budget) == 0
                              ? null
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                      Text(
                                        int.parse(budget) > expense
                                            ? 'Budget Left:'
                                            : 'Budget exceeded by:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Rs. ${(int.parse(budget) - expense).abs()}',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
