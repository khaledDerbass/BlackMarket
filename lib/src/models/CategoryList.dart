class CategoryClass {
  CategoryList? categoryList;

  CategoryClass({this.categoryList});

  CategoryClass.fromJson(Map<String, dynamic> json) {
    categoryList = json['CategoryList'] != null
        ? new CategoryList.fromJson(json['CategoryList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryList != null) {
      data['CategoryList'] = this.categoryList!.toJson();
    }
    return data;
  }
}

class CategoryList {
  int? grocery;
  int? mobiles;
  int? health;
  int? clothes;
  int? frozen;

  CategoryList(
      {this.grocery, this.mobiles, this.health, this.clothes, this.frozen});

  CategoryList.fromJson(Map<String, dynamic> json) {
    grocery = json['Grocery'];
    mobiles = json['Mobiles'];
    health = json['Health'];
    clothes = json['Clothes'];
    frozen = json['Frozen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Grocery'] = this.grocery;
    data['Mobiles'] = this.mobiles;
    data['Health'] = this.health;
    data['Clothes'] = this.clothes;
    data['Frozen'] = this.frozen;
    return data;
  }
}
