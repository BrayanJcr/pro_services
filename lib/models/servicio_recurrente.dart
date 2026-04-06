class ServicioRecurrente {
  final int id;
  final int idUsuario;
  final int idProfesional;
  final int? idTipoServicio;
  final String descripcion;
  final String frecuencia; // 'semanal' | 'quincenal' | 'mensual'
  final int? diaSemana;
  final String? horaInicio;
  final String fechaInicio;
  final String? fechaFin;
  final String estadoRecurrente; // 'activo' | 'pausado' | 'cancelado'
  final String? proximaEjecucion;

  const ServicioRecurrente({
    required this.id,
    required this.idUsuario,
    required this.idProfesional,
    this.idTipoServicio,
    required this.descripcion,
    required this.frecuencia,
    this.diaSemana,
    this.horaInicio,
    required this.fechaInicio,
    this.fechaFin,
    required this.estadoRecurrente,
    this.proximaEjecucion,
  });

  factory ServicioRecurrente.fromJson(Map<String, dynamic> json) =>
      ServicioRecurrente(
        id: json['id'] as int? ?? 0,
        idUsuario: json['idUsuario'] as int? ?? 0,
        idProfesional: json['idProfesional'] as int? ?? 0,
        idTipoServicio: json['idTipoServicio'] as int?,
        descripcion: json['descripcion'] as String? ?? '',
        frecuencia: json['frecuencia'] as String? ?? '',
        diaSemana: json['diaSemana'] as int?,
        horaInicio: json['horaInicio'] as String?,
        fechaInicio: json['fechaInicio'] as String? ?? '',
        fechaFin: json['fechaFin'] as String?,
        estadoRecurrente: json['estadoRecurrente'] as String? ?? 'activo',
        proximaEjecucion: json['proximaEjecucion'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'idUsuario': idUsuario,
        'idProfesional': idProfesional,
        if (idTipoServicio != null) 'idTipoServicio': idTipoServicio,
        'descripcion': descripcion,
        'frecuencia': frecuencia,
        if (diaSemana != null) 'diaSemana': diaSemana,
        if (horaInicio != null) 'horaInicio': horaInicio,
        'fechaInicio': fechaInicio,
        if (fechaFin != null) 'fechaFin': fechaFin,
        'estadoRecurrente': estadoRecurrente,
        if (proximaEjecucion != null) 'proximaEjecucion': proximaEjecucion,
      };
}
