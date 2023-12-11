class Entities {
  int id;
  String category;
  int health;
  String name;
  String spawn;
  String type;
  int streak;

  Entities({
    required this.id,
    required this.category,
    required this.health,
    required this.name,
    required this.spawn,
    required this.type,
    required this.streak,
  });

  factory Entities.fromFirestore(Map<String, dynamic> json) {
    return Entities(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      health: json['health'] ?? 0,
      name: json['name'] ?? '',
      spawn: json['spawn'] ?? '',
      type: json['type'] ?? '',
      streak: json['streak'] ?? 0,
    );
  }
}
