class UserModel {
  String displayName, meta, description;

  UserModel(this.displayName, this.meta, this.description);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['displayName'] = displayName;
    map['description'] = description;
    map['meta'] = meta;

    return map;
  }

  UserModel.fromMapObject(Map<String, dynamic> map){
    this.displayName = map['displayName'];
    this.description = map['description'];
    this.meta = map['meta'];
  }
}
