//*** This provider works when using shared preferences for storing
// shopping list as key value pairs ***

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/db_helper.dart';

class Shopping with ChangeNotifier {
  Map<String, bool> _items = {};

  Map<String, bool> get items {
    return {..._items};
  }

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

  Future<Map<String, bool>> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('shopping_list')) {
      final data = json.decode(prefs.getString('shopping_list'));
      return {...data};
    }
    return {};
  }

  Future<void> addItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('shopping_list')) {
      final data = json.decode(prefs.getString('shopping_list'));
      data[key] = false;
      prefs.setString('shopping_list', json.encode(data));
    }
    else {
      var data = {key: false};
      prefs.setString('shopping_list', json.encode(data));
    }
    notifyListeners();
  }

  Future<void> editItem(String oldKey, String newKey, bool state) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.decode(prefs.getString('shopping_list'));
    print("old key: $oldKey");
    print("State: $state");
    data.remove(oldKey);
    data[newKey] = state;
    print("new key: $newKey");
    prefs.setString('shopping_list', json.encode(data));
    notifyListeners();
  }

  Future<void> toggle(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.decode(prefs.getString('shopping_list'));
    data[key] = !data[key];
    prefs.setString('shopping_list', json.encode(data));
    notifyListeners();
  }

  Future<void> removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.decode(prefs.getString('shopping_list'));
    data.remove(key);
    prefs.setString('shopping_list', json.encode(data));
    notifyListeners();
  }
}