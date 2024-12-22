class Profile {
  final String username;
  final String email;

  Profile({required this.username, required this.email});

  // Factory method to create a Profile object from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json['username'] ?? 'No username available',
      email: json['email'] ?? 'No email available',
    );
  }
}
