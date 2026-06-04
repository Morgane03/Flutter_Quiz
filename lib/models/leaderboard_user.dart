class LeaderboardUser {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String username;
  final int score;

  LeaderboardUser({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.score,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      score: json['score'],
    );
  }
}