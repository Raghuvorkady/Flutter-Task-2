class UserModel {
  String displayName, meta, description;
  int id;

  UserModel(this.displayName, this.meta, this.description);

  UserModel.withId(this.id, this.displayName, this.meta, this.description);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['displayName'] = displayName;
    map['description'] = description;
    map['meta'] = meta;

    return map;
  }

  UserModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.displayName = map['displayName'];
    this.description = map['description'];
    this.meta = map['meta'];
  }
}
