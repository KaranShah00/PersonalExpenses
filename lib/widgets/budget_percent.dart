import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/transactions.dart';

class BudgetPercent extends StatelessWidget {
  final int budget;
  final int expense;

  BudgetPercent(this.budget, this.expense);

  @override
  Widget build(BuildContext context) {
    final bool flag = expense > budget ? true : false;
    print("Budget $budget");
    var color, ratio;
    if (budget != 0) {
      ratio = double.parse((expense / budget).toStringAsFixed(2));
    }
    if (budget == 0) {
      color = Colors.transparent;
      ratio = 0.0;
    } else if (!flag) {
      if (ratio < 0.5) {
        color = Colors.green;
      } else if (ratio < 0.8) {
        color = Colors.yellowAccent;
      } else {
        color = Colors.deepOrange;
      }
    } else {
      color = Colors.red;
    }
    return budget == 0
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Budget amount is not set",
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        : CircularPercentIndicator(
            radius: 200,
            animation: true,
            animationDuration: 1500,
            lineWidth: 40,
            percent: flag ? 1 : ratio,
            center: Text(
              '${(ratio * 100).round()}%',
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            circularStrokeCap: CircularStrokeCap.butt,
            backgroundColor: Colors.grey,
            progressColor: color,
          );
  }
}
