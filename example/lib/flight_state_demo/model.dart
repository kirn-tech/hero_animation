enum Item { one, two, three, four, five, six, seven, eight }

extension ItemX on Item {
  String getTitle(bool landed) {
    switch (this) {
      case Item.one:
        return landed ? "Landed first item" : "First item";
      case Item.two:
        return landed ? "Landed second item" : "Second item";
      case Item.three:
        return landed ? "Landed third item" : "Third item";
      case Item.four:
        return landed ? "Landed fourth item" : "Fourth item";
      case Item.five:
        return landed ? "Landed fifth item" : "Fifth item";
      case Item.six:
        return landed ? "Landed sixth item" : "Sixth item";
      case Item.seven:
        return landed ? "Landed seventh item" : "Seventh item";
      case Item.eight:
        return '\n';
    }
  }
}
