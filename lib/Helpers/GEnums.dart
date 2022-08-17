enum Category {
  mobiles(1),clothes(2),health(3),grocery(4),cars(5),flowers(6),electronics(7),buildings(8),services(9),games(10);

  const Category(this.value);
  final num value;


  factory Category.fromId(int id) {
    return values.firstWhere((e) => e.value == id);
  }
}