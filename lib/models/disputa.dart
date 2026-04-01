class Disputa {
  final int id;
  final int idProyecto;
  final String motivo;
  final String descripcion;
  final String estadoDisputa;
  final String fecha;

  const Disputa({
    required this.id,
    required this.idProyecto,
    required this.motivo,
    required this.descripcion,
    required this.estadoDisputa,
    required this.fecha,
  });

  factory Disputa.fromJson(Map<String, dynamic> json) => Disputa(
        id:            json['id'] as int,
        idProyecto:    json['idProyecto'] as int? ?? 0,
        motivo:        json['motivo'] as String? ?? '',
        descripcion:   json['descripcion'] as String? ?? '',
        estadoDisputa: json['estadoDisputa'] as String? ?? 'Abierta',
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
