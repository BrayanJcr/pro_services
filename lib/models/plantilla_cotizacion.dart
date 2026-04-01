class PlantillaCotizacion {
  final int id;
  final String nombre;
  final double manoObra;
  final double materiales;
  final double traslado;
  final String? observaciones;
  final double total;

  const PlantillaCotizacion({
    required this.id,
    required this.nombre,
    required this.manoObra,
    required this.materiales,
    required this.traslado,
    this.observaciones,
    required this.total,
  });

  factory PlantillaCotizacion.fromJson(Map<String, dynamic> json) => PlantillaCotizacion(
        id:           json['id'] as int,
        nombre:       json['nombre'] as String? ?? '',
        manoObra:     (json['manoObra'] as num?)?.toDouble() ?? 0.0,
        materiales:   (json['materiales'] as num?)?.toDouble() ?? 0.0,
        traslado:     (json['traslado'] as num?)?.toDouble() ?? 0.0,
        observaciones: json['observaciones'] as String?,
        total:        (json['total'] as num?)?.toDouble() ??
                      ((json['manoObra'] as num?)?.toDouble() ?? 0.0) +
                      ((json['materiales'] as num?)?.toDouble() ?? 0.0) +
                      ((json['traslado'] as num?)?.toDouble() ?? 0.0),
      );
}
