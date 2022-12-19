import 'package:flutter/foundation.dart';

class Transaction extends Comparable {
  String id;
  String title;
  int amount;
  DateTime date;

  Transaction({
      @required this.id,
      @required this.title,
      @required this.amount,
      @required this.date
  });

  @override
  int compareTo(other) {
    if(this.date != null && other.date != null) {
      if (this.date.isAfter(other.date)) {
        return -1;
      }
      if (this.date.isAtSameMomentAs(other.date)) {
        //print("FINAL");
        return 0;
      }

      if (this.date.isBefore(other.date)) {
        return 1;
      }
    }
    return null;
  }
}
