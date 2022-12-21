// import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:personalexpenses/models/group.dart';

// import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/db_helper.dart';
import '../models/shopping_item.dart';

class Shopping with ChangeNotifier {

  Map<String,  List<ShoppingItem>> _items = {};
  // List<Group> _groups = [];

  Map<String,  List<ShoppingItem>> get items {
    return {..._items};
  }

  // List<Group> get groups {
  //   return [..._groups];
  // }

  Future<void> fetchItems() async {
    print("in fetch items for debug");
    Map<String,  List<ShoppingItem>> loadedItems = {};
    final dataList = await DBHelper.getData('user_shopping_list');
    print("Length: " + dataList.length.toString());
    print("Type: ${dataList.runtimeType}");
    // loadedGroups = dataList.map((item) {
    //   return Group(
    //     id: item['id'],
    //     name: item['name'],
    //   );
    // }).toList();
    dataList.map((item) {
      print("Inside map");
      String groupId = item['groupId'];
      print("Group of item $item: ${item['groupId']}");
       ShoppingItem i = ShoppingItem(
        id: item['id'],
        title: item['title'],
        status: item['status'],
        groupId: item['groupId'],
      );
      if(loadedItems.containsKey(groupId)){
        loadedItems[groupId].add(i);
      }
      else {
        loadedItems[groupId] = [i];
      }
      print("Inside loaded items: $loadedItems");
    }).toList();
    print("Outside loaded items: $loadedItems");
    _items = loadedItems;
    for(var value in _items.values) {
      value.sort();
    }
    _items.forEach((k,v) => print('Ke-values => ${k}: ${v}'));
  }

  Future<void> addItem(String title, String groupId) async {
    final moment = DateTime.now().toString();
    DBHelper.insert('user_shopping_list', {
      'id': moment,
      'title': title,
      'status': 0,
      'groupId': groupId,
    });
    final newItem = ShoppingItem(
      title: title,
      status: 0,
      id: moment,
      groupId: groupId,
    );
    if(_items.containsKey(groupId)) {
    _items[groupId].add(newItem);
    }
    else {
      _items[groupId] = [newItem];
    }
    notifyListeners();
  }

  void editItem(String id, String title, int status, String groupId) {
    final index = _items[groupId].indexWhere((ele) => ele.id == id);
    _items[groupId][index].title = title;
    _items[groupId][index].status = status;
    DBHelper.editItemData(
        'user_shopping_list', id, title, status);
    notifyListeners();
  }

  void deleteItem(String id, String groupId) {
    _items[groupId].removeWhere((i) => i.id == id);
    DBHelper.deleteItemData('user_shopping_list', id);
    notifyListeners();
  }

  // Future<void> fetchGroups() async {
  //   print("in fetch groups");
  //   List<Group> loadedGroups = [];
  //   final dataList = await DBHelper.getData('user_groups');
  //   print("group Type: ${dataList.runtimeType}");
  //   loadedGroups = dataList.map((item) {
  //     print("in fetch group map");
  //     return Group(
  //       id: item['id'],
  //       name: item['name'],
  //     );
  //   }).toList();
  //   //print("Loaded Transactions $loadedTransactions");
  //   //print("here in provider fetch");
  //   _groups = loadedGroups;
  //   for(var grp in groups) {
  //     print("Group: ${grp.name} id: ${grp.id}");
  //   }
  //   // print("Group2: ${groups[1].name}");
  //   //print("transactions: $transactions");
  // }
  //
  // Future<void> addGroup(String name) async {
  //   final moment = DateTime.now().toString();
  //   DBHelper.insert('user_groups', {
  //     'id': moment,
  //     'name': name,
  //   });
  //   final newGroup = Group(
  //     id: moment,
  //     name: name,
  //   );
  //   _groups.add(newGroup);
  //   notifyListeners();
  // }
  //
  // void editGroup(String id, String name) {
  //   final index = _groups.indexWhere((ele) => ele.id == id);
  //   _groups[index].name = name;
  //   DBHelper.editGroupData('user_groups', id, name);
  //   notifyListeners();
  // }
  //
  // void deleteGroup(String id) {
  //   _groups.removeWhere((g) => g.id == id);
  //   // _items.remove(id);
  //   DBHelper.deleteGroupData('user_groups', id);
  //   notifyListeners();
  // }

//  Future<void> fetch() async {
//    Map<String, bool> loadedItems = {};
//    final dataList = await DBHelper.getShoppingData('shopping_list');
//    if(dataList != null) {
//      dataList.map((item) {
//        loadedItems[item['title']] = item['value'] == 1 ? true : false;
//      });
//      _items = loadedItems;
//      print("Items in shopping $_items");
//    }
//    print("Outside");
//  }
//
//  void addItem(String key) {
//    print("Key $key");
//    DBHelper.shoppingInsert('shopping_list', {
//      'title': key,
//      'value': 0
//    });
//    _items[key] = false;
//    print("Items in insert $_items");
//    notifyListeners();
//  }
//
//  void removeItem(String key) {
//    DBHelper.deleteShoppingData('shopping_list', key);
//    _items.remove(key);
//    notifyListeners();
//  }
//
//  void toggle(String key) {
//    final value = _items[key] == true ? 0 : 1;
//    DBHelper.editShoppingData('shopping_list', key, value);
//     _items[key] = !_items[key];
//     notifyListeners();
//  }

  // Future<Map<String, bool>> fetch() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey('shopping_list')) {
  //     final data = json.decode(prefs.getString('shopping_list'));
  //     return {...data};
  //   }
  //   return {};
  // }
  //
  // Future<void> addItem(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey('shopping_list')) {
  //     final data = json.decode(prefs.getString('shopping_list'));
  //     data[key] = false;
  //     prefs.setString('shopping_list', json.encode(data));
  //   }
  //   else {
  //     var data = {key: false};
  //     prefs.setString('shopping_list', json.encode(data));
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> editItem(String oldKey, String newKey, bool state) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final data = json.decode(prefs.getString('shopping_list'));
  //   print("old key: $oldKey");
  //   print("State: $state");
  //   data.remove(oldKey);
  //   data[newKey] = state;
  //   print("new key: $newKey");
  //   prefs.setString('shopping_list', json.encode(data));
  //   notifyListeners();
  // }
  //
  // Future<void> toggle(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final data = json.decode(prefs.getString('shopping_list'));
  //   data[key] = !data[key];
  //   prefs.setString('shopping_list', json.encode(data));
  //   notifyListeners();
  // }
  //
  // Future<void> removeItem(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final data = json.decode(prefs.getString('shopping_list'));
  //   data.remove(key);
  //   prefs.setString('shopping_list', json.encode(data));
  //   notifyListeners();
  // }
}