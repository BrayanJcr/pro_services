class Nota {
  final int id;
  final String texto;
  final String fecha;

  const Nota({
    required this.id,
    required this.texto,
    required this.fecha,
  });

  factory Nota.fromJson(Map<String, dynamic> json) => Nota(
        id:    json['id'] as int,
        texto: json['texto'] as String,
        fecha: json['fecha'] as String,
      );
}
