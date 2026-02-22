class Profile {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  Profile({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
    );
  }
}
