import 'package:flutter/material.dart';
import 'package:personalexpenses/models/shopping_item.dart';

import 'package:provider/provider.dart';

import '../providers/shopping.dart';
import '../widgets/main_drawer.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<ShoppingItem> items = [];
  final titleController = TextEditingController();
  var editTitleController = TextEditingController();
  final groupController = TextEditingController();
  var editGroupController = TextEditingController();
  var p;
  var _isLoading;
  // var _isInit = true;

  @override
  void initState() {
    print("in init state");
    setState(() {
      _isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("inside widget binding");
      p = Provider.of<Shopping>(context, listen: false);
      await p.fetchItems();
      // print("items before $items");
      // await p.fetchItems();
      //   print("inside");
      //   items = p.items;
      //   print("Items are $items");
        setState(() {
          _isLoading = false;
        });
        print("is loading false");
    });
    super.initState();
  }

  //*** Commenting out initstate and commenting assigning items with provider in build method below
  // along with uncommenting the below didChangeDependencies would work too ***
  // @override
  // void didChangeDependencies() {
  //   print("in did change dependencies");
  //   if(_isInit) {
  //     p = Provider.of<Shopping>(context);
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     print("items before $items");
  //     p.fetchItems().then((val) {
  //       print("inside");
  //       items = p.items;
  //       print("Items are $items");
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   _isInit = false;
  //   }
  //   else{
  //     print("fetching items in else");
  //     items = p.items;
  //   }
  //   super.didChangeDependencies();
  // }

  void _submitData(bool create, [ShoppingItem item = null]) {
    print("In submit data: ${editTitleController.text}");
    if(create) {
    final enteredData = titleController.text;
      if (enteredData.isEmpty) {
        return;
      }
      p.addItem(enteredData, "1"); // edit out group id
    titleController.clear();
    }
    else {
      final enteredData = editTitleController.text;
      if (enteredData.isEmpty) {
        return;
      }
      print("inside else");
      p.editItem(item.id, enteredData, item.status);
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

  void _editItem(ShoppingItem item, BuildContext ctx) {
    editTitleController.text = item.title;
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
                      onSubmitted: (_) => _submitData(false, item),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Edit Item'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _submitData(false, item),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _submitGroup() {
    var enteredData = groupController.text;
    if(enteredData.isEmpty) {
      return;
    }
    p.addGroup(enteredData);
    groupController.clear();
    Navigator.of(context).pop();
  }

  void _addGroup(BuildContext ctx) {
    print("in add group");
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
                      decoration: InputDecoration(labelText: 'Group Name'),
                      textCapitalization: TextCapitalization.sentences,
                      controller: groupController,
                      onSubmitted: (_) => _submitGroup(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Add Group'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _submitGroup(),
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
    print("in shopping build");
    items = Provider.of<Shopping>(context).items;
    // if(p != null) {
    // items = p.items;
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        actions: [
          IconButton(
              icon: Icon(Icons.add), onPressed: () => _addItem(context)),
          FlatButton(
              child: Text("Add group"), onPressed: () => _addGroup(context)),
          FlatButton(
              child: Text("Get group"), onPressed: () => p.fetchGroups()),
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemBuilder: (ctx, index) {
          return CheckboxListTile(
            // key: ValueKey(key),
              value: items[index].status == 1 ? true : false,
              title: Text(
                items[index].title + (items[index].groupId  ??  ""),
                style: TextStyle(
                    fontSize: 20,
                    decoration: items[index].status == 1
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
                    onPressed: () => _editItem(items[index], ctx),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      p.deleteItem(items[index].id);
                    },
                  ),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,

              onChanged: (val) {
                p.editItem(items[index].id, items[index].title, items[index].status == 1 ? 0 : 1);
              });
        },
        itemCount: items.length,
      ),
    );
  }
}
