class UserModel {
  final int? id;
  final String name;
  final String email;
  final String role;
  final String? token;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
