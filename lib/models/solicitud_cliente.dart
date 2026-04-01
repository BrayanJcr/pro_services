class SolicitudCliente {
  final int id;
  final String profesional;
  final String servicio;
  final String descripcion;
  final String fecha;
  final double presupuesto;
  final String estado;

  const SolicitudCliente({
    required this.id,
    required this.profesional,
    required this.servicio,
    required this.descripcion,
    required this.fecha,
    required this.presupuesto,
    required this.estado,
  });

  factory SolicitudCliente.fromJson(Map<String, dynamic> json) =>
      SolicitudCliente(
        id:          json['id'] as int,
        profesional: json['profesional'] as String? ?? '',
        servicio:    json['servicio'] as String? ?? '',
        descripcion: json['descripcion'] as String? ?? '',
        fecha:       _parseDate(json['fecha']),
        presupuesto: (json['presupuesto'] as num?)?.toDouble() ?? 0.0,
        estado:      (json['estado'] as String? ?? '').toLowerCase(),
      );

  static String _parseDate(dynamic value) {
    if (value == null) return '';
    final s = value.toString();
    if (s.isEmpty) return '';
    try {
      final dt = DateTime.parse(s);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return s;
    }
  }
}
