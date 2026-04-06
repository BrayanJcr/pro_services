import 'package:flutter/material.dart';
import 'package:pro_services/main.dart';
import 'package:pro_services/models/servicio_recurrente.dart';
import 'package:pro_services/services/servicio_recurrente_service.dart';
import 'package:pro_services/screens/client/crear_servicio_recurrente_screen.dart';

class MisServiciosRecurrentesScreen extends StatefulWidget {
  final String token;

  const MisServiciosRecurrentesScreen({super.key, required this.token});

  @override
  State<MisServiciosRecurrentesScreen> createState() =>
      _MisServiciosRecurrentesScreenState();
}

class _MisServiciosRecurrentesScreenState
    extends State<MisServiciosRecurrentesScreen> {
  late Future<List<ServicioRecurrente>> _futuro;
  String _filtroEstado = 'todos';

  static const _filtros = ['todos', 'activo', 'pausado', 'cancelado'];

  @override
  void initState() {
    super.initState();
    _futuro = ServicioRecurrenteService.getMis(widget.token);
  }

  void _reload() {
    setState(() {
      _futuro = ServicioRecurrenteService.getMis(widget.token);
    });
  }

  Future<void> _pausar(int id) async {
    try {
      await ServicioRecurrenteService.pausar(widget.token, id);
      if (!mounted) return;
      _showSnack('Servicio pausado', error: false);
      _reload();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Error al pausar: $e', error: true);
    }
  }

  Future<void> _cancelar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar servicio'),
        content: const Text('¿Confirmás que querés cancelar este servicio recurrente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, cancelar',
                style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await ServicioRecurrenteService.cancelar(widget.token, id);
      if (!mounted) return;
      _showSnack('Servicio cancelado', error: false);
      _reload();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Error al cancelar: $e', error: true);
    }
  }

  void _showSnack(String msg, {required bool error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            error ? const Color(0xFFEF4444) : const Color(0xFF10B981),
      ),
    );
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
          'Mis servicios recurrentes',
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.w600)),
        onPressed: () async {
          final resultado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CrearServicioRecurrenteScreen(token: widget.token),
            ),
          );
          if (resultado == true) {
            _showSnack('Servicio recurrente creado', error: false);
            _reload();
          }
        },
      ),
      body: Column(
        children: [
          // ── Chips de filtro ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filtros.map((f) {
                  final activo = _filtroEstado == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f[0].toUpperCase() + f.substring(1)),
                      selected: activo,
                      onSelected: (_) => setState(() => _filtroEstado = f),
                      selectedColor: const Color(0xFF6366F1),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: activo
                            ? Colors.white
                            : (isDark
                                ? Colors.grey.shade300
                                : const Color(0xFF374151)),
                        fontWeight: activo ? FontWeight.w600 : FontWeight.normal,
                      ),
                      backgroundColor:
                          isDark ? const Color(0xFF1E293B) : Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Lista ────────────────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<ServicioRecurrente>>(
              future: _futuro,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _ErrorView(
                      mensaje: snapshot.error.toString(), onRetry: _reload);
                }
                final todos = snapshot.data ?? [];
                final items = _filtroEstado == 'todos'
                    ? todos
                    : todos
                        .where((s) => s.estadoRecurrente == _filtroEstado)
                        .toList();

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.repeat_rounded,
                            size: 56,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          _filtroEstado == 'todos'
                              ? 'No tenés servicios recurrentes'
                              : 'No hay servicios con estado "$_filtroEstado"',
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _ServicioCard(
                    servicio: items[index],
                    isDark: isDark,
                    cardColor: cardColor,
                    onPausar: () => _pausar(items[index].id),
                    onCancelar: () => _cancelar(items[index].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets privados ─────────────────────────────────────────────────────────

class _ServicioCard extends StatelessWidget {
  final ServicioRecurrente servicio;
  final bool isDark;
  final Color cardColor;
  final VoidCallback onPausar;
  final VoidCallback onCancelar;

  const _ServicioCard({
    required this.servicio,
    required this.isDark,
    required this.cardColor,
    required this.onPausar,
    required this.onCancelar,
  });

  Color get _badgeColor {
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
          // ── Cabecera ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicio.descripcion,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: textPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _frecuenciaLabel(servicio.frecuencia),
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Badge estado
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    servicio.estadoRecurrente[0].toUpperCase() +
                        servicio.estadoRecurrente.substring(1),
                    style: TextStyle(
                        color: _badgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          // ── Próxima ejecución ─────────────────────────────────────────────
          if (servicio.proximaEjecucion != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  Icon(Icons.event_rounded, size: 14, color: textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Próxima: ${_formatFecha(servicio.proximaEjecucion!)}',
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                ],
              ),
            ),

          // ── Acciones (solo si activo o pausado) ──────────────────────────
          if (servicio.estadoRecurrente != 'cancelado')
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (servicio.estadoRecurrente == 'activo')
                    _ActionChip(
                      label: 'Pausar',
                      icon: Icons.pause_circle_rounded,
                      color: const Color(0xFFF59E0B),
                      onTap: onPausar,
                    ),
                  if (servicio.estadoRecurrente == 'pausado')
                    _ActionChip(
                      label: 'Reactivar',
                      icon: Icons.play_circle_rounded,
                      color: const Color(0xFF10B981),
                      onTap: onPausar, // reutiliza el endpoint pausar para toggle
                    ),
                  const SizedBox(width: 8),
                  _ActionChip(
                    label: 'Cancelar',
                    icon: Icons.cancel_rounded,
                    color: const Color(0xFFEF4444),
                    onTap: onCancelar,
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }

  String _frecuenciaLabel(String f) {
    switch (f) {
      case 'semanal':
        return 'Cada semana';
      case 'quincenal':
        return 'Cada 2 semanas';
      case 'mensual':
        return 'Cada mes';
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

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
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
