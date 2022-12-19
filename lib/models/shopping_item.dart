import 'package:flutter/foundation.dart';

class ShoppingItem extends Comparable{
  String id;
  String title;
  int status;
  String groupId;

  ShoppingItem({
    @required this.id,
    @required this.title,
    @required this.status,
    this.groupId,
  });

  @override
  int compareTo(other) {
    DateTime date1 = DateTime.parse(this.id);
    DateTime date2 = DateTime.parse(other.id);
    if(date1 != null && date2 != null) {
      if (date1.isAfter(date2)) {
        return 1;
      }
      if (date1.isAtSameMomentAs(date2)) {
        return 0;
      }

      if (date1.isBefore(date2)) {
        return -1;
      }
    }
    return null;
  }
}
