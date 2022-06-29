enum Category {
  clothes(1),mobiles(2),Health(3);

  const Category(this.value);
  final num value;


  factory Category.fromId(int id) {
    return values.firstWhere((e) => e.value == id);
  }
}