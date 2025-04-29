class RegisterModel {
  final String email;
  final String username;
  final String password;

  RegisterModel({
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'password': password,
  };
}
