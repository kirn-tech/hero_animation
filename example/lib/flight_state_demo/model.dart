import 'package:flutter/material.dart';

enum Item { one, two, three, four, five, six, seven, eight }

extension ItemX on Item {
  Color color() {
    switch (this) {
      case Item.one:
        return Colors.red;
      case Item.two:
        return Colors.blue;
      case Item.three:
        return Colors.purpleAccent;
      case Item.four:
        return Colors.green;
      case Item.five:
        return Colors.yellow;
      case Item.six:
        return Colors.cyan;
      case Item.seven:
        return Colors.orange;
      case Item.eight:
        return Colors.transparent;
    }
  }
}
