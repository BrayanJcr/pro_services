class Mensaje {
  final int id;
  final int idProyecto;
  final int idEmisor;
  final String tipoEmisor;
  final String mensaje;
  final bool esLeido;
  final String fecha;

  const Mensaje({
    required this.id,
    required this.idProyecto,
    required this.idEmisor,
    required this.tipoEmisor,
    required this.mensaje,
    required this.esLeido,
    required this.fecha,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        id:         json['id'] as int,
        idProyecto: json['idProyecto'] as int? ?? 0,
        idEmisor:   json['idEmisor'] as int? ?? 0,
        tipoEmisor: json['tipoEmisor'] as String? ?? '',
        mensaje:    json['mensaje'] as String? ?? '',
        esLeido:    json['esLeido'] as bool? ?? false,
        fecha:      _parseDate(json['fechaCreacion']),
      );

  static String _parseDate(dynamic value) {
    if (value == null) return '';
    try {
      final dt = DateTime.parse(value.toString());
      return '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year} ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    } catch (_) { return value.toString(); }
  }
}
