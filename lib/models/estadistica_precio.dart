class EstadisticaPrecio {
  final double min;
  final double max;
  final double promedio;
  final int cantidadMuestras;

  const EstadisticaPrecio({
    required this.min,
    required this.max,
    required this.promedio,
    required this.cantidadMuestras,
  });

  factory EstadisticaPrecio.fromJson(Map<String, dynamic> json) =>
      EstadisticaPrecio(
        min: (json['min'] as num?)?.toDouble() ?? 0.0,
        max: (json['max'] as num?)?.toDouble() ?? 0.0,
        promedio: (json['promedio'] as num?)?.toDouble() ?? 0.0,
        cantidadMuestras: json['cantidadMuestras'] as int? ?? 0,
      );
}
