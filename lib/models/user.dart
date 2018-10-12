class User {
  final int id;
  final String name;
  final String login;
  final String avatarUrl;
  final int publicRepos;
  final int followers;
  final int following;
  final String email;
  final String location;
  final String createdAt;


  User(this.id, this.name, this.login, this.avatarUrl, this.publicRepos,
      this.followers, this.following, this.email, this.location,
      this.createdAt);

  factory User.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new User(
          json['id'],
          json['name'],
          json['login'],
          json['avatar_url'],
          json['public_repos'],
          json['followers'],
          json['following'],
          json['email'],
          json['location'],
          json['created_at']
      );
    }
  }
}
