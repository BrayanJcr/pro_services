class FotoProyecto {
  final int id;
  final String url;
  final String fecha;

  const FotoProyecto({
    required this.id,
    required this.url,
    required this.fecha,
  });

  factory FotoProyecto.fromJson(Map<String, dynamic> json) => FotoProyecto(
        id:    json['id'] as int,
        url:   json['url'] as String,
        fecha: json['fecha'] as String,
      );
}
