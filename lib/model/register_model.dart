class RegisterRequest  {
  final String username;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequest ({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}
