import 'package:flutter/material.dart';

import 'package:personalexpenses/models/shopping_item.dart';

import 'package:provider/provider.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

import '../models/group.dart';
import '../providers/groups.dart';
import '../providers/shopping.dart';

class AccordionContent extends StatefulWidget {
  final Group grp;

  AccordionContent(this.grp);

  @override
  State<AccordionContent> createState() => _AccordionContentState();
}

class _AccordionContentState extends State<AccordionContent> {
  var _isLoading = false;
  var p;
  var p2;
  List<Group> groups = [];
  final titleController = TextEditingController();
  var editTitleController = TextEditingController();
  Map<String, List<ShoppingItem>> items = {};
  Group grp;

  @override
  void initState() {
    if(mounted) {
    grp = widget.grp;
    setState(() {
      _isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      p = Provider.of<Shopping>(context, listen: false);
      p2 = Provider.of<Groups>(context, listen: false);
      await p.fetchItems();
      await p2.fetchGroups();
      setState(() {
        _isLoading = false;
      });
    });
    }
    super.initState();
  }

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
                      controller: editTitleController,
                      onSubmitted: (_) => _submitData(false, groupId, item),
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
                      onPressed: () => _submitData(false, groupId, item),
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
    groups = Provider.of<Groups>(context).groups;
    items = Provider
        .of<Shopping>(context)
        .items;

    return _isLoading ? Center(child: CircularProgressIndicator(),)
    : (!items.containsKey(grp.id) || items[grp.id].length == 0) ? Container() : ListView.builder(
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
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: const Text('Delete Item'),
                                    content:
                                    const Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          p.deleteItem(items[grp.id][index].id, grp.id);
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
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) {
                      p.editItem(items[grp.id][index].id, items[grp.id][index].title,
                          items[grp.id][index].status == 1 ? 0 : 1, grp.id);
                    });
              },
              itemCount: items[grp.id].length,
            );
  }
}
