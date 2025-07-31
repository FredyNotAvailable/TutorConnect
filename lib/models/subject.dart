class Subject {
  final String id;
  final String nombre;

  Subject({
    required this.id,
    required this.nombre,
  });

  factory Subject.fromMap(Map<String, dynamic> map, String documentId) {
    return Subject(
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
