class HitoServicio {
  final int id;
  final int idProyecto;
  final String hito;
  final String? descripcion;
  final String fechaHito;

  const HitoServicio({
    required this.id,
    required this.idProyecto,
    required this.hito,
    this.descripcion,
    required this.fechaHito,
  });

  factory HitoServicio.fromJson(Map<String, dynamic> json) => HitoServicio(
        id:          json['id'] as int? ?? 0,
        idProyecto:  json['idProyecto'] as int? ?? 0,
        hito:        json['hito'] as String? ?? '',
        descripcion: json['descripcion'] as String?,
        fechaHito:   _parseDate(json['fechaHito']),
      );

  static String _parseDate(dynamic value) {
    if (value == null) return '';
    final s = value.toString();
    if (s.isEmpty) return '';
    try {
      final dt = DateTime.parse(s).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} $h:$m';
    } catch (_) {
      return s;
    }
  }
}
