class BusquedaResultado {
  final int id;
  final String nombre;
  final String especialidad;
  final double calificacion;
  final double precioPorHora;
  final bool disponibleAhora;
  final String? ubicacion;
  final double? distanciaKm;
  final int nivelVerificacion;
  final bool esVerificado;

  const BusquedaResultado({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.calificacion,
    required this.precioPorHora,
    required this.disponibleAhora,
    this.ubicacion,
    this.distanciaKm,
    required this.nivelVerificacion,
    required this.esVerificado,
  });

  factory BusquedaResultado.fromJson(Map<String, dynamic> json) {
    return BusquedaResultado(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? '',
      especialidad: json['especialidad'] as String? ?? '',
      calificacion: (json['calificacion'] as num?)?.toDouble() ?? 0.0,
      precioPorHora: (json['precioPorHora'] as num?)?.toDouble() ?? 0.0,
      disponibleAhora: json['disponibleAhora'] as bool? ?? false,
      ubicacion: json['ubicacion'] as String?,
      distanciaKm: (json['distanciaKm'] as num?)?.toDouble(),
      nivelVerificacion: json['nivelVerificacion'] as int? ?? 0,
      esVerificado: json['esVerificado'] as bool? ?? false,
    );
  }
}
