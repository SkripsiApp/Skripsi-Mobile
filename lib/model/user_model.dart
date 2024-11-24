class UserProfile {
  final String id;
  final String name;
  final String username;
  final String email;
  final int point;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.point,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      point: json['point'],
    );
  }
}
