class Notificacion {
  final int id;
  final int idDestinatario;
  final String tipoDestinatario;
  final String titulo;
  final String mensaje;
  final String tipo;
  final int? idReferencia;
  final bool esLeida;
  final String fecha;

  const Notificacion({
    required this.id,
    required this.idDestinatario,
    required this.tipoDestinatario,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    this.idReferencia,
    required this.esLeida,
    required this.fecha,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) => Notificacion(
        id:               json['id'] as int,
        idDestinatario:   json['idDestinatario'] as int? ?? 0,
        tipoDestinatario: json['tipoDestinatario'] as String? ?? '',
        titulo:           json['titulo'] as String? ?? '',
        mensaje:          json['mensaje'] as String? ?? '',
        tipo:             json['tipo'] as String? ?? '',
        idReferencia:     json['idReferencia'] as int?,
        esLeida:          json['esLeida'] as bool? ?? false,
        fecha:            _parseDate(json['fechaCreacion']),
      );

  static String _parseDate(dynamic value) {
    if (value == null) return '';
    try {
      final dt = DateTime.parse(value.toString());
      return '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}';
    } catch (_) { return value.toString(); }
  }
}
