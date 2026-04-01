class Horario {
  final int id;
  final int idProfesional;
  final int diaSemana;
  final String horaInicio;
  final String horaFin;

  const Horario({
    required this.id,
    required this.idProfesional,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
  });

  factory Horario.fromJson(Map<String, dynamic> json) => Horario(
        id:            json['id'] as int,
        idProfesional: json['idProfesional'] as int? ?? 0,
        diaSemana:     json['diaSemana'] as int? ?? 1,
        horaInicio:    json['horaInicio']?.toString() ?? '',
        horaFin:       json['horaFin']?.toString() ?? '',
      );

  String get diaNombre =>
      const ['', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'][diaSemana];
}
