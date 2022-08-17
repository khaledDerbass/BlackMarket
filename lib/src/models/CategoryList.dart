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
  int? flowers;
  int? cars;
  int? buildings;
  int? electronics;
  int? games;
  int? services;


  CategoryList(
      {this.grocery, this.mobiles, this.health, this.clothes, this.flowers,
      this.cars, this.services, this.buildings, this.electronics, this.games});

  CategoryList.fromJson(Map<String, dynamic> json) {
    grocery = json['grocery'];
    mobiles = json['Mobiles'];
    health = json['health'];
    clothes = json['clothes'];
    flowers = json['flowers'];
    cars = json['cars'];
    buildings = json['buildings'];
    electronics = json['electronics'];
    games = json['games'];
    services = json['services'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grocery'] = this.grocery;
    data['Mobiles'] = this.mobiles;
    data['health'] = this.health;
    data['clothes'] = this.clothes;
    data['flowers'] = this.flowers;
    data['cars'] = this.cars;
    data['buildings'] = this.buildings;
    data['services'] = this.services;
    data['electronics'] = this.electronics;
    data['games'] = this.games;

    return data;
  }
}
