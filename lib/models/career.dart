class Career {
  final String id;
  final String nombre;

  Career({
    required this.id,
    required this.nombre,
  });

  factory Career.fromMap(Map<String, dynamic> map, String documentId) {
    return Career(
      id: documentId,
      nombre: map['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }
}
