enum Category {
  mobiles(1),clothes(2),health(3),grocery(4);

  const Category(this.value);
  final num value;


  factory Category.fromId(int id) {
    return values.firstWhere((e) => e.value == id);
  }
}