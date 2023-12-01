class User {
  int id;
  String nick;
  String email;
  int? points;

  User(
      {required this.id, required this.nick, required this.email, this.points});
  factory User.toMap(map) {
    return User(
      id: map['id'] ?? 1,
      nick: map['nome'] ?? "Não Informado",
      email: map['email'] ?? "Não Informado",
      points: map['points'] ?? 0,
    );
  }
  User.fromFirestore(Map<String, dynamic> firestoreMap)
      : id = firestoreMap['id'],
        nick = firestoreMap['nick'],
        email = firestoreMap['email'],
        points = firestoreMap['points'];
}
