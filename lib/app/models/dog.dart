class Dog {
  int _id;
  String _name;
  String _description;

  Dog(this._name, this._description);

  Dog.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._description = obj['description'];
  }

  int get id => _id;
  String get name => _name;
  String get description => _description;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;

    return map;
  }

  Dog.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
  }
}