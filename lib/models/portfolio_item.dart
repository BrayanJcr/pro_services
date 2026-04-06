class PortfolioItem {
  final int idProyecto;
  final String nombreProyecto;
  final String fechaCompletado;
  final List<String> fotoUrls;

  const PortfolioItem({
    required this.idProyecto,
    required this.nombreProyecto,
    required this.fechaCompletado,
    required this.fotoUrls,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) => PortfolioItem(
        idProyecto: json['idProyecto'] as int? ?? 0,
        nombreProyecto: json['nombreProyecto'] as String? ?? '',
        fechaCompletado: json['fechaCompletado'] as String? ?? '',
        fotoUrls: (json['fotoUrls'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );
}
