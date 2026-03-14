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
  });

  factory Profesional.fromJson(Map<String, dynamic> json) {
    return Profesional(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      especialidad: json['especialidad'] as String,
      calificacion: (json['calificacion'] as num).toDouble(),
      trabajosRealizados: json['trabajosRealizados'] as int,
      ubicacion: json['ubicacion'] as String,
      precioPorHora: (json['precioPorHora'] as num).toDouble(),
      horarioDisponibilidad: json['horarioDisponibilidad'] as String,
      habilidades: List<String>.from(json['habilidades'] as List),
      disponibleAhora: json['disponibleAhora'] as bool,
      telefono: json['telefono'] as String,
      correo: json['correo'] as String,
      sitioWeb: json['sitioWeb'] as String?,
      sobreMi: json['sobreMi'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
