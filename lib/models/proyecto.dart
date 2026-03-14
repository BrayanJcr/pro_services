class Proyecto {
  final int id;
  final String cliente;
  final String telefono;
  final String correo;
  final String servicio;
  final String descripcion;
  final String ubicacion;
  final String fecha;
  final String fechaInicio;
  final String fechaFin;
  final double presupuesto;
  final String estado;
  final double progreso;

  const Proyecto({
    required this.id,
    required this.cliente,
    required this.telefono,
    required this.correo,
    required this.servicio,
    required this.descripcion,
    required this.ubicacion,
    required this.fecha,
    required this.fechaInicio,
    required this.fechaFin,
    required this.presupuesto,
    required this.estado,
    required this.progreso,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) => Proyecto(
        id:           json['id'] as int,
        cliente:      json['cliente'] as String,
        telefono:     json['telefono'] as String,
        correo:       json['correo'] as String,
        servicio:     json['servicio'] as String,
        descripcion:  json['descripcion'] as String,
        ubicacion:    json['ubicacion'] as String,
        fecha:        json['fecha'] as String,
        fechaInicio:  json['fecha_inicio'] as String,
        fechaFin:     json['fecha_fin'] as String,
        presupuesto:  (json['presupuesto'] as num).toDouble(),
        estado:       json['estado'] as String,
        progreso:     (json['progreso'] as num).toDouble(),
      );
}
