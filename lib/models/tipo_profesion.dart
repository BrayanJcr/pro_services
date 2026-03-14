class TipoProfesion {
  final int id;
  final String nombre;
  final String descripcion;
  final String icono; // clave para mapear al IconData
  final String color; // hex string ej: "F59E0B"
  final int profesionalesRegistrados;

  const TipoProfesion({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.profesionalesRegistrados,
  });

  factory TipoProfesion.fromJson(Map<String, dynamic> json) {
    return TipoProfesion(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      icono: json['icono'] as String,
      color: json['color'] as String,
      profesionalesRegistrados: json['profesionalesRegistrados'] as int,
    );
  }
}
