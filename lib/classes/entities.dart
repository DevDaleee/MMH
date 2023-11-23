class Entities {
  int id;
  String name;
  String spawn;
  int health;
  String type;
  String category;

  Entities({
    required this.id,
    required this.name,
    required this.spawn,
    required this.health,
    required this.type,
    required this.category,
  });

  factory Entities.toMap(map) {
    return Entities(
      id: map['id'] ?? 0,
      name: map['name'] ?? "Não Informado",
      spawn: map['type'] ?? "Não Informado",
      health: map['height'] ?? "Não Informado",
      type: map['width'] ?? "Não Informado",
      category: map['category'] ?? "Não Informado",
    );
  }
}
