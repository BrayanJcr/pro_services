class ResenaCliente {
  final int id;
  final int idProfesional;
  final int idUsuario;
  final int idProyecto;
  final int puntaje;
  final String? comentario;
  final String fecha;

  const ResenaCliente({
    required this.id,
    required this.idProfesional,
    required this.idUsuario,
    required this.idProyecto,
    required this.puntaje,
    this.comentario,
    required this.fecha,
  });

  factory ResenaCliente.fromJson(Map<String, dynamic> json) => ResenaCliente(
        id:            json['id'] as int,
        idProfesional: json['idProfesional'] as int? ?? 0,
        idUsuario:     json['idUsuario'] as int? ?? 0,
        idProyecto:    json['idProyecto'] as int? ?? 0,
        puntaje:       json['puntaje'] as int? ?? 1,
        comentario:    json['comentario'] as String?,
        fecha:         _parseDate(json['fechaCreacion']),
      );

  static String _parseDate(dynamic value) {
    if (value == null) return '';
    try {
      final dt = DateTime.parse(value.toString());
      return '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}';
    } catch (_) { return value.toString(); }
  }
}
