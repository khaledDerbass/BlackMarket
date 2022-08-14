class StoryTime {
  StoryDurration? storyDurration;

  StoryTime({this.storyDurration});

  StoryTime.fromJson(Map<String, dynamic> json) {
    storyDurration = json['StoryDurration'] != null
        ? new StoryDurration.fromJson(json['StoryDurration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.storyDurration != null) {
      data['StoryDurration'] = this.storyDurration!.toJson();
    }
    return data;
  }
}

class StoryDurration {
  int? one;
  int? two;
  int? three;
  int? four;
  int? five;
  int? six;
  int? seven;

  StoryDurration(
      {this.one,
        this.two,
        this.three,
        this.four,
        this.five,
        this.six,
        this.seven});

  StoryDurration.fromJson(Map<String, dynamic> json) {
    one = json['One'];
    two = json['Two'];
    three = json['Three'];
    four = json['Four'];
    five = json['Five'];
    six = json['Six'];
    seven = json['Seven'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['One'] = this.one;
    data['Two'] = this.two;
    data['Three'] = this.three;
    data['Four'] = this.four;
    data['Five'] = this.five;
    data['Six'] = this.six;
    data['Seven'] = this.seven;
    return data;
  }
}
