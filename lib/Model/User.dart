class User {
  int? id;
  String name;
  int age;

  User({this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'age': age,
    };
    if (id != null)
      map['id'] = id;
    return map;
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        age = map['age'];
}
