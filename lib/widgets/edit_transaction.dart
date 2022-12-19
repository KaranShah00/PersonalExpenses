import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../models/transaction.dart';

class EditTransaction extends StatefulWidget {
  final Transaction item;

  EditTransaction(this.item);

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  var titleController;
  var amountController;
  DateTime _selectedDate;
  var p;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    amountController = TextEditingController(text: widget.item.amount.toString());
    p = Provider.of<Transactions>(context, listen: false);
    _selectedDate = widget.item.date;

  }

  void _submitData() {
    //print("called");
    final enteredData = titleController.text;
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredAmount = int.parse(amountController.text);

    if (enteredData.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    //print("reached");
    p.editTransaction(widget.item.id, enteredData, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
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
                decoration: InputDecoration(labelText: 'Title'),
                textCapitalization: TextCapitalization.sentences,
                controller: titleController,
                onSubmitted: (_) => _submitData(),
                //onChanged: (val){
                //titleInput = val;
                //},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                //onChanged: (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                    Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat.yMMMd().format(_selectedDate),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Edit Transaction'),
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
