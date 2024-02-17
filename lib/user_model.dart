class User {
  final int id;
  final String name;
  final String family;
  final int age;

  User(
      {required this.id,
      required this.name,
      required this.family,
      required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: int.parse(json['id']),
        name: json['name'],
        family: json['family'],
        age:int.parse(json['age']));
  }
}
