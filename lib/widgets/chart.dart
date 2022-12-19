import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import './chart_bar.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  int get totalSpending {
    return groupedTransactions.fold(0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactions.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'], data['amount'],
                    totalSpending == 0 ? 0 :(data['amount'] as int) / totalSpending
                ),
              );
            }).toList(),
          ),
        ),
      );
  }
}
