class Cotizacion {
  final int id;
  final int idUsuario;
  final int idProfesional;
  final int idTipoServicio;
  final String fechaServicio;
  final String horaInicio;
  final String horaFin;
  final double precioPropuesto;
  final String estadoCotizacion;
  final String observaciones;

  const Cotizacion({
    required this.id,
    required this.idUsuario,
    required this.idProfesional,
    required this.idTipoServicio,
    required this.fechaServicio,
    required this.horaInicio,
    required this.horaFin,
    required this.precioPropuesto,
    required this.estadoCotizacion,
    required this.observaciones,
  });

  factory Cotizacion.fromJson(Map<String, dynamic> json) => Cotizacion(
        id: json['id'] as int,
        idUsuario: json['idUsuario'] as int? ?? 0,
        idProfesional: json['idProfesional'] as int? ?? 0,
        idTipoServicio: json['idTipoServicio'] as int? ?? 0,
        fechaServicio: json['fechaServicio']?.toString() ?? '',
        horaInicio: json['horaInicio']?.toString() ?? '',
        horaFin: json['horaFin']?.toString() ?? '',
        precioPropuesto: (json['precioPropuesto'] as num?)?.toDouble() ?? 0.0,
        estadoCotizacion: json['estadoCotizacion'] as String? ?? 'Pendiente',
        observaciones: json['observaciones'] as String? ?? '',
      );
}
