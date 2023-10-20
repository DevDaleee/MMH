class Entities {
  int id;
  String name;
  String type;
  double height;
  double width;
  String category;

  Entities({
    required this.id,
    required this.name,
    required this.type,
    required this.height,
    required this.width,
    required this.category,
  });

  factory Entities.toMap(map) {
    return Entities(
      id: map['id'] ?? 0,
      name: map['name'] ?? "Não Informado",
      type: map['type'] ?? "Não Informado",
      height: map['height'] ?? "Não Informado",
      width: map['width'] ?? "Não Informado",
      category: map['category'] ?? "Não Informado",
    );
  }
}
