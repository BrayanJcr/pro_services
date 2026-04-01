class Resena {
  final int id;
  final String nombreUsuario;
  final String titulo;
  final String descripcion;
  final int puntaje;
  final String fecha;

  const Resena({
    required this.id,
    required this.nombreUsuario,
    required this.titulo,
    required this.descripcion,
    required this.puntaje,
    required this.fecha,
  });

  factory Resena.fromJson(Map<String, dynamic> json) => Resena(
        id:            json['id'] as int,
        nombreUsuario: json['nombreUsuario'] as String? ?? 'Usuario',
        titulo:        json['titulo'] as String? ?? '',
        descripcion:   json['descripcion'] as String? ?? '',
        puntaje:       json['puntaje'] as int? ?? 0,
        fecha:         _parseDate(json['fechaCreacion']),
      );

  static String _parseDate(dynamic value) {
    if (value == null) return '';
    try {
      final dt = DateTime.parse(value.toString());
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return value.toString();
    }
  }
}
