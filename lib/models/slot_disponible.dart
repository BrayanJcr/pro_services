class SlotDisponible {
  final String fecha;
  final int diaSemana;
  final String horaInicio;
  final String horaFin;
  final bool disponible;

  const SlotDisponible({
    required this.fecha,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
    required this.disponible,
  });

  factory SlotDisponible.fromJson(Map<String, dynamic> json) => SlotDisponible(
        fecha: json['fecha'] as String? ?? '',
        diaSemana: json['diaSemana'] as int? ?? 0,
        horaInicio: json['horaInicio'] as String? ?? '',
        horaFin: json['horaFin'] as String? ?? '',
        disponible: json['disponible'] as bool? ?? false,
      );
}
