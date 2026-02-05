class User {
  final String email;
  final String? token;
  final String? username;
  final int? formsId;

  User({required this.email, this.token, this.username, this.formsId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      token: json['token'], 
      username: json['username'],
      formsId: json['forms_id'],
    );
  }
}
