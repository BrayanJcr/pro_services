class Profesional {
  final int id;
  final String nombre;
  final String especialidad;
  final double calificacion;
  final int trabajosRealizados;
  final String ubicacion;
  final double precioPorHora;
  final String horarioDisponibilidad;
  final List<String> habilidades;
  final bool disponibleAhora;
  final String telefono;
  final String correo;
  final String? sitioWeb;
  final String sobreMi;
  final String? avatarUrl;
  final bool esVerificado;
  final int nivelVerificacion;
  final double? latitud;
  final double? longitud;
  final double? distanciaKm; // calculado en el cliente, no viene del API directamente
  final int aniosExperiencia;

  const Profesional({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.calificacion,
    required this.trabajosRealizados,
    required this.ubicacion,
    required this.precioPorHora,
    required this.horarioDisponibilidad,
    required this.habilidades,
    required this.disponibleAhora,
    required this.telefono,
    required this.correo,
    this.sitioWeb,
    required this.sobreMi,
    this.avatarUrl,
    required this.esVerificado,
    this.nivelVerificacion = 0,
    this.latitud,
    this.longitud,
    this.distanciaKm,
    required this.aniosExperiencia,
  });

  factory Profesional.fromJson(Map<String, dynamic> json) {
    return Profesional(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? '',
      especialidad: json['especialidad'] as String? ?? '',
      calificacion: (json['calificacion'] as num?)?.toDouble() ?? 0.0,
      trabajosRealizados: json['trabajosRealizados'] as int? ?? 0,
      ubicacion: json['ubicacion'] as String? ?? '',
      precioPorHora: (json['precioPorHora'] as num?)?.toDouble() ?? 0.0,
      horarioDisponibilidad: json['horarioDisponibilidad'] as String? ?? '',
      habilidades: _parseHabilidades(json['habilidades']),
      disponibleAhora: json['disponibleAhora'] as bool? ?? false,
      telefono: json['telefono'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      sitioWeb: json['sitioWeb'] as String?,
      sobreMi: json['sobreMi'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      esVerificado: json['esVerificado'] as bool? ?? false,
      nivelVerificacion: json['nivelVerificacion'] as int? ?? 0,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      distanciaKm: (json['distanciaKm'] as num?)?.toDouble(),
      aniosExperiencia: json['aniosExperiencia'] as int? ?? 0,
    );
  }

  /// La API devuelve habilidades como string separado por comas.
  static List<String> _parseHabilidades(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value);
    return (value as String)
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
