import 'package:flutter/material.dart';
import 'package:pro_services/main.dart';
import 'package:pro_services/models/proyecto.dart';
import 'package:pro_services/services/proyecto_service.dart';
import 'package:pro_services/screens/client/chat_proyecto_screen.dart';
import 'package:pro_services/screens/professional/detalle_proyecto_screen.dart';

class ConversacionesProfesionalScreen extends StatefulWidget {
  const ConversacionesProfesionalScreen({super.key, required this.token});
  final String token;

  @override
  State<ConversacionesProfesionalScreen> createState() =>
      _ConversacionesProfesionalScreenState();
}

class _ConversacionesProfesionalScreenState
    extends State<ConversacionesProfesionalScreen> {
  late Future<List<Proyecto>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = ProyectoService.getProyectos(widget.token);
  }

  void _reload() => setState(
      () => _futuro = ProyectoService.getProyectos(widget.token));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        title: const Text(
          'Conversaciones',
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
      body: FutureBuilder<List<Proyecto>>(
        future: _futuro,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return _ErrorView(
                error: snap.error.toString(), onRetry: _reload);
          }
          final lista = snap.data!;
          if (lista.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded,
                      size: 64,
                      color: isDark
                          ? Colors.grey.shade600
                          : Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No tenés proyectos aún',
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cuando aceptes solicitudes aparecerán aquí',
                    style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 16),
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final p = lista[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ProyectoConversacionCard(
                    proyecto: p,
                    isDark: isDark,
                    onDetalle: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleProyectoScreen(
                            id: p.id,
                            cliente: p.cliente,
                            telefono: p.telefono,
                            correo: p.correo,
                            servicio: p.servicio,
                            descripcion: p.descripcion,
                            ubicacion: p.ubicacion,
                            fecha: p.fecha,
                            fechaInicio: p.fechaInicio,
                            fechaFin: p.fechaFin,
                            presupuesto: p.presupuesto,
                            estado: p.estado,
                            progreso: p.progreso,
                            token: widget.token,
                            idUsuario: p.idUsuario,
                          ),
                        ),
                      );
                      _reload();
                    },
                    onChat: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatProyectoScreen(
                          token: widget.token,
                          proyectoId: p.id,
                          nombreProfesional: p.cliente,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _ProyectoConversacionCard extends StatelessWidget {
  const _ProyectoConversacionCard({
    required this.proyecto,
    required this.isDark,
    required this.onDetalle,
    required this.onChat,
  });

  final Proyecto proyecto;
  final bool isDark;
  final VoidCallback onDetalle;
  final VoidCallback onChat;

  Color get _estadoColor {
    switch (proyecto.estado) {
      case 'pendiente':
        return const Color(0xFFF59E0B);
      case 'aceptado':
        return const Color(0xFF6366F1);
      case 'completado':
        return const Color(0xFF22C55E);
      case 'rechazado':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  String get _estadoLabel {
    switch (proyecto.estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'aceptado':
        return 'En progreso';
      case 'completado':
        return 'Completado';
      case 'rechazado':
        return 'Rechazado';
      default:
        return proyecto.estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final initial = proyecto.cliente.isNotEmpty
        ? proyecto.cliente[0].toUpperCase()
        : '?';
    final esActivo = proyecto.estado == 'aceptado';

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cabecera ──────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      _estadoColor.withValues(alpha: 0.18),
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _estadoColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proyecto.cliente,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        proyecto.servicio,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _estadoColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _estadoLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _estadoColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Precio + Ubicación ─────────────────────────────────────
            Row(
              children: [
                Icon(Icons.attach_money_rounded,
                    size: 16, color: const Color(0xFF22C55E)),
                const SizedBox(width: 4),
                Text(
                  'Presupuesto: \$${proyecto.presupuesto.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (proyecto.ubicacion.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 13, color: textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      proyecto.ubicacion,
                      style:
                          TextStyle(fontSize: 12, color: textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.calendar_today_rounded,
                      size: 13, color: textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    proyecto.fecha,
                    style:
                        TextStyle(fontSize: 12, color: textSecondary),
                  ),
                ],
              ),

            // ── Descripción ────────────────────────────────────────────
            if (proyecto.descripcion.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                proyecto.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13, color: textSecondary, height: 1.4),
              ),
            ],

            // ── Barra de progreso (solo si está activo) ────────────────
            if (esActivo) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso del proyecto',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimary),
                  ),
                  Text(
                    '${(proyecto.progreso * 100).toInt()}%',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: proyecto.progreso,
                  minHeight: 7,
                  backgroundColor: const Color(0xFF6366F1)
                      .withValues(alpha: isDark ? 0.15 : 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF6366F1)),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Separador ─────────────────────────────────────────────
            Divider(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.06),
              height: 1,
            ),
            const SizedBox(height: 12),

            // ── Acciones ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDetalle,
                    icon: const Icon(Icons.info_outline_rounded, size: 15),
                    label: const Text('Ver detalles',
                        style: TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6366F1),
                      side: const BorderSide(color: Color(0xFF6366F1)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onChat,
                    icon: const Icon(Icons.chat_rounded, size: 15),
                    label: const Text('Chat',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 56,
                color: isDark
                    ? Colors.grey.shade600
                    : Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los datos',
              style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
