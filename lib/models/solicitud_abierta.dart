class SolicitudAbierta {
  final int id;
  final int idUsuario;
  final int idTipoProfesion;
  final String titulo;
  final String descripcion;
  final double? presupuestoMax;
  final String? ubicacion;
  final String? fechaLimite;
  final bool esUrgente;
  final String estadoSolicitud; // 'abierta' | 'en_revision' | 'cerrada'
  final String fecha;
  final String? nombreUsuario;
  final String? nombreTipoProfesion;

  const SolicitudAbierta({
    required this.id,
    required this.idUsuario,
    required this.idTipoProfesion,
    required this.titulo,
    required this.descripcion,
    this.presupuestoMax,
    this.ubicacion,
    this.fechaLimite,
    required this.esUrgente,
    required this.estadoSolicitud,
    required this.fecha,
    this.nombreUsuario,
    this.nombreTipoProfesion,
  });

  factory SolicitudAbierta.fromJson(Map<String, dynamic> json) =>
      SolicitudAbierta(
        id:                 json['id'] as int,
        idUsuario:          json['idUsuario'] as int? ?? 0,
        idTipoProfesion:    json['idTipoProfesion'] as int? ?? 0,
        titulo:             json['titulo'] as String? ?? '',
        descripcion:        json['descripcion'] as String? ?? '',
        presupuestoMax:     (json['presupuestoMax'] as num?)?.toDouble(),
        ubicacion:          json['ubicacion'] as String?,
        fechaLimite:        _parseDate(json['fechaLimite']),
        esUrgente:          json['esUrgente'] as bool? ?? false,
        estadoSolicitud:    (json['estadoSolicitud'] as String? ?? 'abierta').toLowerCase(),
        fecha:              _parseDate(json['fecha']) ?? '',
        nombreUsuario:      json['nombreUsuario'] as String?,
        nombreTipoProfesion: json['nombreTipoProfesion'] as String?,
      );

  static String? _parseDate(dynamic value) {
    if (value == null) return null;
    final s = value.toString();
    if (s.isEmpty) return null;
    try {
      final dt = DateTime.parse(s);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return s;
    }
  }
}
