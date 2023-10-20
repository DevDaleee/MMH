class User {
  int id;
  String nick;
  String email;

  User({
    required this.id,
    required this.nick,
    required this.email,
  });
  factory User.toMap(map) {
    return User(
      id: map['id'] ?? 1,
      nick: map['nome'] ?? "Não Informado",
      email: map['email'] ?? "Não Informado",
    );
  }
}
