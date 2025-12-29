class UserModel {
  final String id;
  final String email;
  final String? name;

  UserModel({required this.id, required this.email, this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
    );
  }
}

class AuthResponse {
  final String token;
  final UserModel? user;
  final String? message;

  AuthResponse({required this.token, this.user, this.message});
}
