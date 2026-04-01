class Venta {
  final int id;
  final int idCotizacion;
  final double montoTotal;
  final String? fechaPago;
  final String metodoPago;
  final String codigoOperacion;
  final int idProfesional;
  final int idUsuario;
  final String fechaCotizacion;
  final String fecha;

  const Venta({
    required this.id,
    required this.idCotizacion,
    required this.montoTotal,
    this.fechaPago,
    required this.metodoPago,
    required this.codigoOperacion,
    required this.idProfesional,
    required this.idUsuario,
    required this.fechaCotizacion,
    required this.fecha,
  });

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        id:               json['id'] as int,
        idCotizacion:     json['idCotizacion'] as int? ?? 0,
        montoTotal:       (json['montoTotal'] as num?)?.toDouble() ?? 0.0,
        fechaPago:        json['fechaPago'] as String?,
        metodoPago:       json['metodoPago'] as String? ?? '',
        codigoOperacion:  json['codigoOperacion'] as String? ?? '',
        idProfesional:    json['idProfesional'] as int? ?? 0,
        idUsuario:        json['idUsuario'] as int? ?? 0,
        fechaCotizacion:  _parseDate(json['fechaCotizacion']),
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
