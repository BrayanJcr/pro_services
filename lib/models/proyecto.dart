class Proyecto {
  final int id;
  final int idUsuario;
  final String cliente;
  final String telefono;
  final String correo;
  final String servicio;
  final String descripcion;
  final String ubicacion;
  final String fecha;
  final String fechaInicio;
  final String fechaFin;
  final double presupuesto;
  final String estado;
  final double progreso;

  const Proyecto({
    required this.id,
    required this.idUsuario,
    required this.cliente,
    required this.telefono,
    required this.correo,
    required this.servicio,
    required this.descripcion,
    required this.ubicacion,
    required this.fecha,
    required this.fechaInicio,
    required this.fechaFin,
    required this.presupuesto,
    required this.estado,
    required this.progreso,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) => Proyecto(
        id:          json['id'] as int? ?? 0,
        idUsuario:   json['idUsuario'] as int? ?? 0,
        cliente:     json['cliente'] as String? ?? '',
        telefono:    json['telefono'] as String? ?? '',
        correo:      json['correo'] as String? ?? '',
        servicio:    json['servicio'] as String? ?? '',
        descripcion: json['descripcion'] as String? ?? '',
        ubicacion:   json['ubicacion'] as String? ?? '',
        fecha:       _parseDate(json['fecha']),
        fechaInicio: _parseDate(json['fechaInicio']),
        fechaFin:    _parseDate(json['fechaFin']),
        presupuesto: (json['presupuesto'] as num?)?.toDouble() ?? 0.0,
        estado:      (json['estado'] as String? ?? '').toLowerCase(),
        progreso:    (json['progreso'] as num?)?.toDouble() ?? 0.0,
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
