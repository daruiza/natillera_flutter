class User {
  final String name;
  final String email;
  final String pictureUrl;

  User({required this.name, required this.email, required this.pictureUrl});

  @override
  String toString() {
    return 'User(name: $name, email: $email, pictureUrl: $pictureUrl)';
  }
}
