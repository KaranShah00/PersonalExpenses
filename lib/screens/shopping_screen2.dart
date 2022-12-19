//*** This screen works when using shared preferences for storing
// shopping list as key value pairs ***

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/shopping.dart';
import '../widgets/main_drawer.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  Map<String, bool> items = {};
  final titleController = TextEditingController();
  var editTitleController = TextEditingController();
  var p;
  var _isLoading;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    print("in did change dependencies");
    if(_isInit) {
      p = Provider.of<Shopping>(context);
      setState(() {
        _isLoading = true;
      });
      print("items before $items");
      p.fetch().then((val) {
        print("inside");
        items = val;
        print("Items are $items");
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _submitData(bool create, [String oldKey = null]) {
    print("In submit data: ${editTitleController.text}");
    if(create) {
      final enteredData = titleController.text;
      if (enteredData.isEmpty) {
        return;
      }
      p.addItem(enteredData);
      items[enteredData] = false;
      titleController.clear();
    }
    else {
      final enteredData = editTitleController.text;
      if (enteredData.isEmpty) {
        return;
      }
      print("inside else");
      bool state = items[oldKey];
      p.editItem(oldKey, enteredData, state);
      items.remove(oldKey);
      items[enteredData] = state;
      editTitleController.clear();
    }
    print("before pop");
    Navigator.of(context).pop();
    print("after pop");
    print("items first $items");
  }

  void _addItem(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bctx) {
          return Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      textCapitalization: TextCapitalization.sentences,
                      controller: titleController,
                      onSubmitted: (_) => _submitData(true),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Add Item'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _submitData(true),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _editItem(String oldKey, BuildContext ctx) {
    editTitleController.text = oldKey;
    print("In edit text: ${editTitleController.text}");
    // titleController.text = key;
    showModalBottomSheet(
        context: ctx,
        builder: (bctx) {
          return Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      textCapitalization: TextCapitalization.sentences,
                      controller: editTitleController,
                      onSubmitted: (_) => _submitData(false, oldKey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Edit Item'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _submitData(false, oldKey),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        actions: [
          IconButton(
              icon: Icon(Icons.add), onPressed: () => _addItem(context))
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemBuilder: (ctx, index) {
          String key = items.keys.elementAt(index);
          return CheckboxListTile(
            // key: ValueKey(key),
              value: items[key],
              title: Text(
                key,
                style: TextStyle(
                    fontSize: 20,
                    decoration: items[key]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              secondary: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    onPressed: () => _editItem(key, ctx),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      p.removeItem(key);
                      items.remove(key);
                    },
                  ),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,

              onChanged: (val) {
                p.toggle(key);
                items[key] = !items[key];
              });
        },
        itemCount: items.length,
      ),
    );
  }
}
