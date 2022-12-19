import 'package:flutter/material.dart';
import 'package:personalexpenses/models/shopping_item.dart';

import 'package:provider/provider.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

import '../models/group.dart';
import '../providers/shopping.dart';
import '../widgets/main_drawer.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  Map<String, List<ShoppingItem>> items = {};
  List<Group> groups = [];
  final titleController = TextEditingController();
  var editTitleController = TextEditingController();
  final groupController = TextEditingController();
  var editGroupController = TextEditingController();
  var p;
  var _isLoading;

  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);

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
      print("fetched items");
      await p.fetchGroups();
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

  void _submitData(bool create, String groupId, [ShoppingItem item]) {
    print("In submit data: ${editTitleController.text}");
    if (create) {
      final enteredData = titleController.text;
      if (enteredData.isEmpty) {
        return;
      }
      p.addItem(enteredData, groupId); // edit out group id
      titleController.clear();
    } else {
      final enteredData = editTitleController.text;
      if (enteredData.isEmpty) {
        return;
      }
      print("inside else");
      p.editItem(item.id, enteredData, item.status, groupId);
      editTitleController.clear();
    }
    print("before pop");
    Navigator.of(context).pop();
    print("after pop");
    print("items first $items");
  }

  void _addItem(BuildContext ctx, String groupId) {
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
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 10,
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
                      onSubmitted: (_) => _submitData(true, groupId),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Add Item'),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _submitData(true, groupId),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _editItem(ShoppingItem item, BuildContext ctx, String groupId) {
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
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 10,
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
                      onSubmitted: (_) => _submitData(false, groupId, item),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Edit Item'),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _submitData(false, groupId, item),
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
    if (enteredData.isEmpty) {
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
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 10,
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
                      color: Theme
                          .of(context)
                          .primaryColor,
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
    items = Provider
        .of<Shopping>(context)
        .items;
    groups = Provider
        .of<Shopping>(context)
        .groups;
    // if(p != null) {
    // items = p.items;
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => _addGroup(context))
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Accordion(
          // maxOpenSections: 2,
          headerBackgroundColorOpened: Colors.black54,
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          headerPadding:
          const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            children: groups
                .map(
                  (grp) =>
                  AccordionSection(
                    isOpen: false,
                    headerBackgroundColor: Colors.black38,
                    headerBackgroundColorOpened: Colors.black54,
                    header: Text(grp.name, style: _headerStyle),
                    rightIcon: IconButton(icon: Icon(Icons.add), onPressed: () => _addItem(context, grp.id),),
                    content: (!items.containsKey(grp.id) || items[grp.id].length == 0) ? null : ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return CheckboxListTile(
                          // key: ValueKey(key),
                            value: items[grp.id][index].status == 1 ? true : false,
                            title: Text(
                              items[grp.id][index].title,
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: items[grp.id][index].status == 1
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
                                  onPressed: () =>
                                      _editItem(items[grp.id][index], ctx, grp.id),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    p.deleteItem(items[grp.id][index].id, grp.id);
                                  },
                                ),
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (val) {
                              p.editItem(items[grp.id][index].id, items[grp.id][index].title,
                                  items[grp.id][index].status == 1 ? 0 : 1, grp.id);
                            });
                      },
                      itemCount: items[grp.id].length,
                    ),
                  ),
            ).toList(),
      ),
    ),);
  }
}
