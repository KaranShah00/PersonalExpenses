import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';

class NewTransaction extends StatefulWidget {

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  var p;

  @override
  void initState() {
    super.initState();
    p = Provider.of<Transactions>(context, listen: false);
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
    p.addNewTransaction(enteredData, enteredAmount, _selectedDate);
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
                child: Text('Add Transaction'),
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
