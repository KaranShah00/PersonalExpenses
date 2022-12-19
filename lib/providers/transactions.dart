import 'package:flutter/foundation.dart';

import '../models/transaction.dart';
import '../helpers/db_helper.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get monthlyTransactions {
    List<Transaction> monthlyTransactions = _transactions
        .where((item) =>
            item.date.month == DateTime.now().month &&
            item.date.year == DateTime.now().year)
        .toList();
    monthlyTransactions.sort();
    return monthlyTransactions;
  }

  List<Transaction> get transactions {
    return [..._transactions];
  }

  int totalExpense() {
    var sum = 0;
    for (var i in _transactions) {
      if (i.date.month == DateTime.now().month &&
          i.date.year == DateTime.now().year) {
        sum += i.amount;
      }
    }
    return sum;
  }

  Transaction costliestTransaction() {
    Transaction t;
    int amount = 0;
    for (var i in _transactions) {
      if (i.amount > amount) {
        amount = i.amount;
        t = i;
      }
    }
    return t;
  }

  Future<void> fetchTransactions() async {
    List<Transaction> loadedTransactions = [];
    final dataList = await DBHelper.getData('user_expenses');
    loadedTransactions = dataList.map((item) {
      return Transaction(
        id: item['id'],
        title: item['title'],
        amount: item['amount'],
        date: DateTime.parse(item['date']),
      );
    }).toList();
    //print("Loaded Transactions $loadedTransactions");
    //print("here in provider fetch");
    _transactions = loadedTransactions;
    _transactions.sort();
    //print("transactions: $transactions");
  }

  Future<void> addNewTransaction(
      String txTitle, int txAmount, DateTime chosenDate) async {
    final moment = DateTime.now().toString();
    DBHelper.insert('user_expenses', {
      'id': moment,
      'title': txTitle,
      'amount': txAmount,
      'date': chosenDate.toString(),
    });
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: moment,
    );
    _transactions.add(newTx);
    notifyListeners();
  }

  void editTransaction(
      String id, String txTitle, int txAmount, DateTime chosenDate) {
    final index = _transactions.indexWhere((ele) => ele.id == id);
    _transactions[index].title = txTitle;
    _transactions[index].amount = txAmount;
    _transactions[index].date = chosenDate;
    DBHelper.editData(
        'user_expenses', id, txTitle, txAmount, chosenDate.toString());
    notifyListeners();
  }

  void editAmount(String id, int amount) {
    final item = _transactions.firstWhere((ele) => ele.id == id);
    item.amount += amount;
    DBHelper.editShoppingData('user_expenses', id, item.amount);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    DBHelper.deleteData('user_expenses', id);
    notifyListeners();
  }
}
