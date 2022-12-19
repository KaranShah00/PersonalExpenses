import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transactions.dart';
import '../widgets/main_drawer.dart';
import '../widgets/edit_transaction.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedDate1 = DateTime.now();
  DateTime _selectedDate2 = DateTime.now();
  var p;
  bool searched = false;
  List<Transaction> _loadedTransactions = [];

  @override
  void initState() {
    super.initState();
    _selectedDate1 = _selectedDate1.subtract(Duration(
        hours: _selectedDate1.hour,
        minutes: _selectedDate1.minute,
        seconds: _selectedDate1.second,
        milliseconds: _selectedDate1.millisecond,
        microseconds: _selectedDate1.microsecond));
  }

  void _presentDatePicker(bool first) {
    showDatePicker(
      context: context,
      initialDate: first ? _selectedDate1 : _selectedDate2,
      firstDate: first ? DateTime(2020) : _selectedDate1,
      lastDate: first ? _selectedDate2 : DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        if (first) {
          _selectedDate1 = pickedDate;
        } else {
          _selectedDate2 = pickedDate;
          _selectedDate2 = _selectedDate2.add(Duration(
              hours: 23,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999));
        }
      });
    });
  }

  void _startEditTransaction(BuildContext ctx, Transaction item) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return EditTransaction(item);
      },
    ).whenComplete(() => _fetchResults());
  }

  void _fetchResults() {
    List<Transaction> results = p.transactions
        .where((item) =>
            (item.date.isAfter(_selectedDate1) ||
                item.date.isAtSameMomentAs(_selectedDate1)) &&
            (item.date.isBefore(_selectedDate2) ||
                item.date.isAtSameMomentAs(_selectedDate2)))
        .toList();
    setState(() {
      _loadedTransactions = results;
      searched = true;
//      print(_selectedDate1);
//      print(_selectedDate2);
    });
  }

  @override
  Widget build(BuildContext context) {
    p = Provider.of<Transactions>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 5,
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'From',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => _presentDatePicker(true),
                        ),
                        Text(
                          _selectedDate1 == null
                              ? 'No Date Chosen!'
                              : DateFormat.yMMMd().format(_selectedDate1),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'To',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => _presentDatePicker(false),
                        ),
                        Text(
                          _selectedDate2 == null
                              ? 'No Date Chosen!'
                              : DateFormat.yMMMd().format(_selectedDate2),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RaisedButton(
              color: Colors.deepPurple,
              child: Text(
                'Search',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: _fetchResults,
            ),
            if (searched)
              _loadedTransactions.length == 0
                  ? Text(
                      'No transactions found',
                      style: Theme.of(context).textTheme.headline6,
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _loadedTransactions.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 5,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          child: ListTile(
                            key: ValueKey(DateTime.now().toString()),
                            leading: CircleAvatar(
                              radius: 30,
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: FittedBox(
                                  child: Text(
                                    'Rs.${_loadedTransactions[index].amount}',
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              _loadedTransactions[index].title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            subtitle: Text(
                              DateFormat.yMMMd()
                                  .format(_loadedTransactions[index].date),
                            ),
                            trailing: MediaQuery.of(context).size.width > 460
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FlatButton.icon(
                                        onPressed: () => _startEditTransaction(
                                            ctx, _loadedTransactions[index]),
                                        icon: Icon(Icons.edit),
                                        label: Text('Edit'),
                                      ),
                                      FlatButton.icon(
                                        onPressed: () {
                                          p.deleteTransaction(
                                              _loadedTransactions[index].id);
                                          _fetchResults();
                                        },
                                        icon: Icon(Icons.delete),
                                        label: Text('Delete'),
                                        textColor: Theme.of(context).errorColor,
                                      ),
                                    ],
                                  )
//                      : FittedBox(        // alternative for MainAxisSize.min for correct working of Row inside trailing in ListTile
//                        fit: BoxFit.fill,
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => _startEditTransaction(
                                            ctx, _loadedTransactions[index]),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Theme.of(context).errorColor,
                                          onPressed: () {
                                            p.deleteTransaction(
                                                _loadedTransactions[index].id);
                                            _fetchResults();
                                          }),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
          ],
        ),
      ),
    );
  }
}
