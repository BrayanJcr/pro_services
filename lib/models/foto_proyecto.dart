class FotoProyecto {
  final int id;
  final String url;
  final String fecha;
  final String tipoFoto;    // 'antes' | 'durante' | 'despues'
  final String? descripcion;

  const FotoProyecto({
    required this.id,
    required this.url,
    required this.fecha,
    this.tipoFoto = 'durante',
    this.descripcion,
  });

  factory FotoProyecto.fromJson(Map<String, dynamic> json) => FotoProyecto(
        id:          json['id'] as int? ?? 0,
        url:         json['url'] as String? ?? '',
        fecha:       json['fechaCreacion'] as String? ?? json['fecha'] as String? ?? '',
        tipoFoto:    json['tipoFoto'] as String? ?? 'durante',
        descripcion: json['descripcion'] as String?,
      );
}
