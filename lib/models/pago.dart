class Pago {
  final int id;
  final int idUsuario;
  final int idProfesional;
  final double monto;
  final String moneda;
  final String estadoPago;
  final String? metodoPago;
  final String? fechaCaptura;
  final String? fechaLiberacion;
  final String fecha;

  const Pago({
    required this.id,
    required this.idUsuario,
    required this.idProfesional,
    required this.monto,
    required this.moneda,
    required this.estadoPago,
    this.metodoPago,
    this.fechaCaptura,
    this.fechaLiberacion,
    required this.fecha,
  });

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        id:               json['id'] as int,
        idUsuario:        json['idUsuario'] as int? ?? 0,
        idProfesional:    json['idProfesional'] as int? ?? 0,
        monto:            (json['monto'] as num?)?.toDouble() ?? 0.0,
        moneda:           json['moneda'] as String? ?? 'PEN',
        estadoPago:       (json['estadoPago'] as String? ?? 'pendiente').toLowerCase(),
        metodoPago:       json['metodoPago'] as String?,
        fechaCaptura:     _parseDate(json['fechaCaptura']),
        fechaLiberacion:  _parseDate(json['fechaLiberacion']),
        fecha:            _parseDate(json['fechaCreacion']) ?? '',
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
