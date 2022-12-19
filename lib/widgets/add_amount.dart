import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../models/transaction.dart';

class AddAmount extends StatefulWidget {
  final Transaction item;

  AddAmount(this.item);

  @override
  _AddAmountState createState() => _AddAmountState();
}

class _AddAmountState extends State<AddAmount> {
  final amountController = TextEditingController();
  var p;

  @override
  void initState() {
    super.initState();
    p = Provider.of<Transactions>(context, listen: false);
  }

  void _submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredAmount = int.parse(amountController.text);

    if (enteredAmount <= 0) {
      return;
    }
    p.editAmount(widget.item.id, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top:10,
            left:10,
            right:10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              RaisedButton(
                child: Text('Add Amount'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
