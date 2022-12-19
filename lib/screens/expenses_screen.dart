import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../widgets/chart.dart';
import '../models/transaction.dart';
import '../providers/transactions.dart';
import '../widgets/edit_transaction.dart';
import '../widgets/main_drawer.dart';
import '../widgets/add_amount.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  var _showChart = false;
  var _isInit = true;
  var _isLoading = false;
  List<Transaction> _userTransactions = [];

  @override
  void didChangeDependencies() {
    final p = Provider.of<Transactions>(context);
    if(_isInit) {
      setState(() {
        _isLoading = true;
      });
      p.fetchTransactions().then((value) {
        _userTransactions = p.transactions;
        //print("Main transactions: $_userTransactions");
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    else{
      _userTransactions = p.transactions;
    }
    super.didChangeDependencies();
  }

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    if (_isInit) {
////      const url =
////          'https://flutter-personal-expenses.firebaseio.com/transactions.json';
//      setState(() {
//        _isLoading = true;
//      });
////      final response = http.get(url).then((response) {
////        final extractedData =
////            json.decode(response.body) as Map<String, dynamic>;
//      //List<Transaction> loadedTransactions = [];
////        if (extractedData != null) {
////          extractedData.forEach((txId, txData) {
////            loadedTransactions.add(Transaction(
////              id: txId,
////              title: txData['title'],
////              amount: txData['amount'],
////              date: DateTime.parse(txData['date']),
////            ));
////          });
////        }
////      DBHelper.getData('user_expenses').then((dataList) {
////        loadedTransactions = dataList.map((item) {
////          return Transaction(
////            id: item['id'],
////            title: item['title'],
////            amount: item['amount'],
////            date: DateTime.parse(item['date']),
////          );
////        }).toList();
////      final transactionP = Provider.of<Transactions>(context);
////      transactionP.fetchTransactions();
////      _userTransactions =  transactionP.transactions;
////        setState(() {
////          //_userTransactions = loadedTransactions;
////          _isLoading = false;
////        });
//    }
//    _isInit = false;
//  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

//  Future<void> _addNewTransaction(
//      String txTitle, int txAmount, DateTime chosenDate) async {
////    const url =
////        'https://flutter-personal-expenses.firebaseio.com/transactions.json';
////    setState(() {
////      _isLoading = true;
////    });
//    try {
//      final moment = DateTime.now().toString();
//      DBHelper.insert('user_expenses', {
//        'id': moment,
//        'title': txTitle,
//        'amount': txAmount,
//        'date': chosenDate.toString(),
//      });
////      final response = await http.post(
////        url,
////        body: json.encode({
////          'title': txTitle,
////          'amount': txAmount,
////          'date': chosenDate.toString(),
////        }),
////      );
//      final newTx = Transaction(
//        title: txTitle,
//        amount: txAmount,
//        date: chosenDate,
//        id: moment,
//      );
//      setState(() {
//        _userTransactions.add(newTx);
//        //_isLoading = false;
//      });
//    } catch (error) {
//      print(error.toString());
//    }
//  }

//  void _editTransaction(String id, String txTitle, int txAmount, DateTime chosenDate) {
//    final item = _userTransactions.firstWhere((ele) => ele.id == id);
//    setState(() {
//      item.title = txTitle;
//      item.amount = txAmount;
//      item.date = chosenDate;
//    });
//    DBHelper.editData('user_expenses', id, item.title, item.amount, item.date.toString());
//  }

//  void _deleteTransaction(String id) {
////    var url =
////        'https://flutter-personal-expenses.firebaseio.com/transactions/$id.json';
//    //print(id);
//    //print(_userTransactions.length);
//    setState(() {
//      _userTransactions.removeWhere((tx) => tx.id == id);
//    });
//    //print('After');
//    //print(_userTransactions.length);
//    DBHelper.deleteData('user_expenses', id);
////    setState(() {
////      _isLoading = true;
////    });
////    return http.delete(
////      url,
////      headers: <String, String>{
////        'Content-Type': 'application/json; charset=UTF-8',
////      },
////    ).then((http.Response response) {
////      setState(() {
////        _isLoading = false;
////        _userTransactions.removeWhere((tx) => tx.id == id);
////      });
////      return true;
////    });
//  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewTransaction();
      },
    );
  }

  void _startEditTransaction(BuildContext ctx, String id) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        final item = _userTransactions.firstWhere((item) => item.id == id);
        return EditTransaction(item);
      },
    );
  }

  void _startEditAmount(BuildContext ctx, String id) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        final item = _userTransactions.firstWhere((item) => item.id == id);
        return AddAmount(item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txList = Container(
      height: (MediaQuery.of(context).size.height -
          appBar.preferredSize.height -
          MediaQuery.of(context).padding.top) *
          0.6,
      child: TransactionList(_startEditTransaction, _startEditAmount),
    );

    return Scaffold(
      appBar: appBar,
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txList,
            if (isLandscape)
              _showChart
                  ? Container(
                height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                    0.7,
                child: Chart(_recentTransactions),
              )
                  : txList,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}