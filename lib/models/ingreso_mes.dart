class IngresoMes {
  final int completados;
  final double ingresoEstimado;
  final int nuevosClientes;

  const IngresoMes({
    required this.completados,
    required this.ingresoEstimado,
    required this.nuevosClientes,
  });

  factory IngresoMes.fromJson(Map<String, dynamic> json) => IngresoMes(
        completados:     json['completados'] as int? ?? 0,
        ingresoEstimado: (json['ingresoEstimado'] as num?)?.toDouble() ?? 0.0,
        nuevosClientes:  json['nuevosClientes'] as int? ?? 0,
      );
}
