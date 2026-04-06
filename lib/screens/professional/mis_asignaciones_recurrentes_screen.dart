import 'package:flutter/material.dart';
import 'package:pro_services/main.dart';
import 'package:pro_services/models/servicio_recurrente.dart';
import 'package:pro_services/services/servicio_recurrente_service.dart';

class MisAsignacionesRecurrentesScreen extends StatefulWidget {
  final String token;

  const MisAsignacionesRecurrentesScreen({super.key, required this.token});

  @override
  State<MisAsignacionesRecurrentesScreen> createState() =>
      _MisAsignacionesRecurrentesScreenState();
}

class _MisAsignacionesRecurrentesScreenState
    extends State<MisAsignacionesRecurrentesScreen> {
  late Future<List<ServicioRecurrente>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = ServicioRecurrenteService.getMisAsignados(widget.token);
  }

  void _reload() {
    setState(() {
      _futuro = ServicioRecurrenteService.getMisAsignados(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        title: const Text(
          'Mis asignaciones recurrentes',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: isDark
                  ? const Color(0xFFFBBF24)
                  : const Color(0xFF6366F1),
            ),
            onPressed: () => MyApp.of(context).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<ServicioRecurrente>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(
                mensaje: snapshot.error.toString(), onRetry: _reload);
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_rounded,
                      size: 56,
                      color: isDark
                          ? Colors.grey.shade600
                          : Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No tenés asignaciones recurrentes',
                    style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: items.length,
            itemBuilder: (context, index) => _AsignacionCard(
              servicio: items[index],
              isDark: isDark,
              cardColor: cardColor,
            ),
          );
        },
      ),
    );
  }
}

// ── Widgets privados ─────────────────────────────────────────────────────────

class _AsignacionCard extends StatelessWidget {
  final ServicioRecurrente servicio;
  final bool isDark;
  final Color cardColor;

  const _AsignacionCard({
    required this.servicio,
    required this.isDark,
    required this.cardColor,
  });

  static const _diasNombre = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
    6: 'Sábado',
    7: 'Domingo',
  };

  Color get _estadoColor {
    switch (servicio.estadoRecurrente) {
      case 'activo':
        return const Color(0xFF10B981);
      case 'pausado':
        return const Color(0xFFF59E0B);
      case 'cancelado':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Descripción + badge estado ────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.repeat_rounded,
                    color: Color(0xFF6366F1), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  servicio.descripcion,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _estadoColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  servicio.estadoRecurrente[0].toUpperCase() +
                      servicio.estadoRecurrente.substring(1),
                  style: TextStyle(
                      color: _estadoColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Detalles en grid ──────────────────────────────────────────────
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _DetailItem(
                icon: Icons.autorenew_rounded,
                label: 'Frecuencia',
                value: _frecuenciaLabel(servicio.frecuencia),
                textColor: textSecondary,
              ),
              if (servicio.diaSemana != null)
                _DetailItem(
                  icon: Icons.calendar_view_week_rounded,
                  label: 'Día',
                  value: _diasNombre[servicio.diaSemana] ?? '—',
                  textColor: textSecondary,
                ),
              if (servicio.horaInicio != null)
                _DetailItem(
                  icon: Icons.access_time_rounded,
                  label: 'Hora',
                  value: servicio.horaInicio!,
                  textColor: textSecondary,
                ),
              if (servicio.proximaEjecucion != null)
                _DetailItem(
                  icon: Icons.event_rounded,
                  label: 'Próxima',
                  value: _formatFecha(servicio.proximaEjecucion!),
                  textColor: textSecondary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _frecuenciaLabel(String f) {
    switch (f) {
      case 'semanal':
        return 'Semanal';
      case 'quincenal':
        return 'Quincenal';
      case 'mensual':
        return 'Mensual';
      default:
        return f;
    }
  }

  String _formatFecha(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textColor),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 10, color: textColor)),
            Text(value,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ],
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String mensaje;
  final VoidCallback onRetry;

  const _ErrorView({required this.mensaje, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('Error al cargar los datos'),
          const SizedBox(height: 8),
          Text(mensaje,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
