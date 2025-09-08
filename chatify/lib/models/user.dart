class User {
  final String id;
  final String email;
  final String name;
  final String role;
  User({required this.id, required this.email, required this.name, required this.role});
  factory User.fromJson(Map<String,dynamic> json) => User(
    id: json['id'] ?? json['_id'],
    email: json['email'],
    name: json['name'] ?? '',
    role: json['role'] ?? '',
  );
}
