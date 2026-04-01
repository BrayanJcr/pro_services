import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pro_services/main.dart';
import 'package:pro_services/models/venta.dart';
import 'package:pro_services/services/venta_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.token});
  final String token;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Venta>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = VentaService.getMisCobros(widget.token);
  }

  void _reload() {
    setState(() {
      _futuro = VentaService.getMisCobros(widget.token);
    });
  }

  Map<int, double> _calcularMensuales(List<Venta> ventas) {
    final Map<int, double> monthlyTotals = {};
    final now = DateTime.now();
    for (final v in ventas) {
      if (v.fechaPago == null) continue;
      try {
        final dt = DateTime.parse(v.fechaPago!);
        final diff =
            (now.year - dt.year) * 12 + now.month - dt.month;
        if (diff < 6) {
          monthlyTotals[5 - diff] =
              (monthlyTotals[5 - diff] ?? 0) + v.montoTotal;
        }
      } catch (_) {}
    }
    return monthlyTotals;
  }

  String _nombreMes(int offset) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month - (5 - offset));
    const nombres = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    final mesIndex = ((dt.month - 1) % 12 + 12) % 12;
    return nombres[mesIndex];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Mi Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            ),
            onPressed: () => MyApp.of(context).toggleTheme(),
          ),
        ],
      ),
      body: FutureBuilder<List<Venta>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(
              error: snapshot.error.toString(),
              onRetry: _reload,
            );
          }
          final ventas = snapshot.data ?? [];
          final totalCobrado =
              ventas.fold<double>(0, (sum, v) => sum + v.montoTotal);
          final monthlyTotals = _calcularMensuales(ventas);
          final recientes = ventas.length > 5
              ? ventas.sublist(ventas.length - 5)
              : ventas;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary cards
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: 'Total Cobrado',
                        value:
                            'S/ ${totalCobrado.toStringAsFixed(2)}',
                        icon: Icons.attach_money_rounded,
                        color: Colors.green,
                        cardColor: cardColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Proyectos',
                        value: ventas.length.toString(),
                        icon: Icons.work_rounded,
                        color: primary,
                        cardColor: cardColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Monthly bar chart
                Text(
                  'Ingresos por Mes',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ventas.isEmpty
                      ? const Center(
                          child: Text(
                            'Sin datos de ingresos',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: monthlyTotals.values.isEmpty
                                ? 100
                                : monthlyTotals.values.reduce(
                                        (a, b) => a > b ? a : b) *
                                    1.2,
                            barTouchData:
                                BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              show: true,
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) =>
                                      Text(
                                    'S/${value.toInt()}',
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) =>
                                      Text(
                                    _nombreMes(value.toInt()),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(6, (i) {
                              final amount =
                                  monthlyTotals[i] ?? 0.0;
                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: amount,
                                    color: primary,
                                    width: 16,
                                    borderRadius:
                                        const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Recent payments
                Text(
                  'Cobros Recientes',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (ventas.isEmpty)
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Aún no tenés cobros registrados',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                else
                  ...recientes.reversed.map(
                    (v) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.receipt_long_rounded,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cobro #${v.id}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  v.fecha,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'S/ ${v.montoTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.cardColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
