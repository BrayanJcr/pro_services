class SolicitudCliente {
  final int id;
  final String profesional;
  final String servicio;
  final String descripcion;
  final String fecha;
  final double presupuesto;
  final String estado;

  const SolicitudCliente({
    required this.id,
    required this.profesional,
    required this.servicio,
    required this.descripcion,
    required this.fecha,
    required this.presupuesto,
    required this.estado,
  });

  factory SolicitudCliente.fromJson(Map<String, dynamic> json) =>
      SolicitudCliente(
        id:           json['id'] as int,
        profesional:  json['profesional'] as String,
        servicio:     json['servicio'] as String,
        descripcion:  json['descripcion'] as String,
        fecha:        json['fecha'] as String,
        presupuesto:  (json['presupuesto'] as num).toDouble(),
        estado:       json['estado'] as String,
      );
}
