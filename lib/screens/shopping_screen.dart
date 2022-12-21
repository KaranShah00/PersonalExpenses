import 'package:flutter/material.dart';
import 'package:personalexpenses/models/shopping_item.dart';

import 'package:provider/provider.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

import '../models/group.dart';
import '../providers/groups.dart';
import '../providers/shopping.dart';
import '../widgets/main_drawer.dart';
import '../widgets/accordion_content.dart';

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
  var p2;
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
      p = Provider.of<Groups>(context, listen: false);
      p2 = Provider.of<Shopping>(context, listen: false);
      // await p.fetchItems();
      print("fetched items");
      await p.fetchGroups();
      groups = p.groups;
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
      p2.addItem(enteredData, groupId); // edit out group id
      titleController.clear();
    } else {
      final enteredData = editTitleController.text;
      if (enteredData.isEmpty) {
        return;
      }
      print("inside else");
      p2.editItem(item.id, enteredData, item.status, groupId);
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
                    .of(bctx)
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
                          .of(bctx)
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

  // void _editItem(ShoppingItem item, BuildContext ctx, String groupId) {
  //   editTitleController.text = item.title;
  //   print("In edit text: ${editTitleController.text}");
  //   // titleController.text = key;
  //   showModalBottomSheet(
  //       context: ctx,
  //       builder: (bctx) {
  //         return Card(
  //           elevation: 5,
  //           child: Container(
  //             padding: EdgeInsets.only(
  //               top: 10,
  //               left: 10,
  //               right: 10,
  //               bottom: MediaQuery
  //                   .of(context)
  //                   .viewInsets
  //                   .bottom + 10,
  //             ),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   TextField(
  //                     decoration: InputDecoration(labelText: 'Title'),
  //                     textCapitalization: TextCapitalization.sentences,
  //                     controller: editTitleController,
  //                     onSubmitted: (_) => _submitData(false, groupId, item),
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   RaisedButton(
  //                     child: Text('Edit Item'),
  //                     color: Theme
  //                         .of(context)
  //                         .primaryColor,
  //                     textColor: Colors.white,
  //                     onPressed: () => _submitData(false, groupId, item),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  void submitGroup(bool create, [Group group]) {
    if (create) {
      final enteredData = groupController.text;
      if (enteredData.isEmpty) {
        return;
      }
      p.addGroup(enteredData);
      groupController.clear();
    } else {
      final enteredData = editGroupController.text;
      if (enteredData.isEmpty) {
        return;
      }
      p.editGroup(group.id, enteredData);
      editGroupController.clear();
    }
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
                    .of(bctx)
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
                      onSubmitted: (_) => submitGroup(true),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Add Group'),
                      color: Theme
                          .of(bctx)
                          .primaryColor,
                      textColor: Colors.white,
                      onPressed: () => submitGroup(true),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _editGroup(Group group, BuildContext ctx) {
    editGroupController.text = group.name;
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
                    .of(bctx)
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
                      controller: editGroupController,
                      onSubmitted: (_) => submitGroup(false, group),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Edit Item'),
                      color: Theme
                          .of(bctx)
                          .primaryColor,
                      textColor: Colors.white,
                      onPressed: () => submitGroup(false, group),
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
    // items = Provider
    //     .of<Shopping>(context)
    //     .items;
    groups = Provider
        .of<Groups>(context)
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
          : Accordion(
        paddingListHorizontal: 25,
        maxOpenSections: 100,
        headerBackgroundColorOpened: Colors.black54,
        scaleWhenAnimating: true,
        openAndCloseAnimation: true,
        headerPadding:
        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        children: groups
            .map(
              (grp) =>
              AccordionSection(
                isOpen: true,
                headerBackgroundColor: Colors.deepPurple.shade700,
                //Colors.black38,
                headerBackgroundColorOpened: Colors.deepPurple.shade900,
                //Colors.black54,
                flipRightIconIfOpen: true,
                header: Row(
                  children: [
                    Text(grp.name, style: _headerStyle),
                    Spacer(),
                    IconButton(icon: Icon(Icons.add, color: Colors.white,),
                      onPressed: () => _addItem(context, grp.id),),
                    IconButton(icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _editGroup(grp, context),),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red,),
                      onPressed: ()
                      {
                      showDialog(
                      context: context,
                      builder: (context) =>
                      AlertDialog(
                      title: const Text('Delete Group'),
                      content:
                      const Text(
                      'Are you sure you want to delete this group?'),
                      actions: [
                      TextButton(
                      onPressed: () {
                      p.deleteGroup(grp.id);
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
      rightIcon: Icon(
          Icons.arrow_drop_down_outlined, color: Colors.white),
      content: AccordionContent(grp),
    ),
    ).toList(),
    ),
    );
  }
}
