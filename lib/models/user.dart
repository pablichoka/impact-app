class User {
  String name;
  String lastName;
  String username;
  String email;
  DateTime joinDate;
  bool isPremium;
  DateTime? birthDate;

  User({
    required this.name,
    required this.lastName,
    required this.username,
    required this.email,
    required this.joinDate,
    required this.isPremium,
    this.birthDate,
  });
}
