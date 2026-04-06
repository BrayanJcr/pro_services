class PerfilClientePublico {
  final int id;
  final String nombre;
  final int proyectosCompletados;
  final double calificacionPromedio;
  final int totalResenasRecibidas;
  final String miembroDesde;

  const PerfilClientePublico({
    required this.id,
    required this.nombre,
    required this.proyectosCompletados,
    required this.calificacionPromedio,
    required this.totalResenasRecibidas,
    required this.miembroDesde,
  });

  factory PerfilClientePublico.fromJson(Map<String, dynamic> json) =>
      PerfilClientePublico(
        id:                    json['id'] as int? ?? 0,
        nombre:                json['nombre'] as String? ?? '',
        proyectosCompletados:  json['proyectosCompletados'] as int? ?? 0,
        calificacionPromedio:  (json['calificacionPromedio'] as num?)?.toDouble() ?? 0.0,
        totalResenasRecibidas: json['totalResenasRecibidas'] as int? ?? 0,
        miembroDesde:          json['miembroDesde'] as String? ?? '',
      );
}
