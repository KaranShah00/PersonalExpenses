import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transactions.dart';

class TransactionList extends StatelessWidget {
  final Function _startEditTransaction;
  final Function _startEditAmount;

  TransactionList(this._startEditTransaction, this._startEditAmount);

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<Transactions>(context);
    final _userTransactions = p.monthlyTransactions;
    return _userTransactions.isEmpty
        ? LayoutBuilder(builder: (bctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png')),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  key: ValueKey(DateTime.now().toString()),
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                          'Rs.${_userTransactions[index].amount}',
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    _userTransactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(_userTransactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FlatButton.icon(
                              onPressed: () => _startEditAmount(
                                  ctx, _userTransactions[index].id),
                              icon: Icon(Icons.add),
                              label: Text('Add'),
                            ),
                            FlatButton.icon(
                              onPressed: () => _startEditTransaction(
                                  ctx, _userTransactions[index].id),
                              icon: Icon(Icons.edit),
                              label: Text('Edit'),
                            ),
                            FlatButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete expense'),
                                    content: const Text(
                                        'Are you sure you want to delete this expense?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          p.deleteTransaction(
                                              _userTransactions[index].id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'No',
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
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
                              onPressed: () => _startEditAmount(
                                  ctx, _userTransactions[index].id),
                              icon: Icon(Icons.add),
                            ),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _startEditTransaction(
                                    ctx, _userTransactions[index].id)),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(
                                        title: const Text('Delete expense'),
                                        content: const Text(
                                            'Are you sure you want to delete this expense?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              p.deleteTransaction(
                                                  _userTransactions[index].id);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                ),
                //),
              );

//                return Card(
//                  child: Row(
//                    children: <Widget>[
//                      Container(
//                        margin:
//                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                        decoration: BoxDecoration(
//                            border: Border.all(
//                                color: Theme.of(context).primaryColor,
//                                width: 2)),
//                        padding: EdgeInsets.all(10),
//                        child: Text(
//                          'Rs.${_userTransactions[index].amount}',
//                          style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            fontSize: 20,
//                            color: Theme.of(context).primaryColor,
//                          ),
//                        ),
//                      ),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            _userTransactions[index].title,
//                            style: Theme.of(context).textTheme.headline6,
//                          ),
//                          Text(
//                            DateFormat.yMMMd()
//                                .format(_userTransactions[index].date),
//                            style: TextStyle(color: Colors.grey),
//                          ),
//                        ],
//                      )
//                    ],
//                  ),
//                );
            },
            itemCount: _userTransactions.length,
          );
  }
}
