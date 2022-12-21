import 'package:flutter/foundation.dart';
import 'package:personalexpenses/models/group.dart';

import '../helpers/db_helper.dart';
import '../models/shopping_item.dart';

class Groups with ChangeNotifier {

  List<Group> _groups = [];

  List<Group> get groups {
    return [..._groups];
  }

  Future<void> fetchGroups() async {
    print("in fetch groups");
    List<Group> loadedGroups = [];
    final dataList = await DBHelper.getData('user_groups');
    print("group Type: ${dataList.runtimeType}");
    loadedGroups = dataList.map((item) {
      print("in fetch group map");
      return Group(
        id: item['id'],
        name: item['name'],
      );
    }).toList();
    //print("Loaded Transactions $loadedTransactions");
    //print("here in provider fetch");
    _groups = loadedGroups;
    for(var grp in groups) {
      print("Group: ${grp.name} id: ${grp.id}");
    }
    // print("Group2: ${groups[1].name}");
    //print("transactions: $transactions");
  }

  Future<void> addGroup(String name) async {
    final moment = DateTime.now().toString();
    DBHelper.insert('user_groups', {
      'id': moment,
      'name': name,
    });
    final newGroup = Group(
      id: moment,
      name: name,
    );
    _groups.add(newGroup);
    notifyListeners();
  }

  void editGroup(String id, String name) {
    final index = _groups.indexWhere((ele) => ele.id == id);
    _groups[index].name = name;
    DBHelper.editGroupData('user_groups', id, name);
    notifyListeners();
  }

  void deleteGroup(String id) {
    _groups.removeWhere((g) => g.id == id);
    // _items.remove(id);
    DBHelper.deleteGroupData('user_groups', id);
    notifyListeners();
  }
}