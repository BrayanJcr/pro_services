import 'package:flutter/material.dart';
import 'package:pro_services/main.dart';
import 'package:pro_services/models/solicitud_cliente.dart';
import 'package:pro_services/services/solicitud_service.dart';
import 'package:pro_services/screens/client/chat_proyecto_screen.dart';
import 'package:pro_services/screens/client/detalle_solicitud_screen.dart';

class ConversacionesClienteScreen extends StatefulWidget {
  const ConversacionesClienteScreen({super.key, required this.token});
  final String token;

  @override
  State<ConversacionesClienteScreen> createState() =>
      _ConversacionesClienteScreenState();
}

class _ConversacionesClienteScreenState
    extends State<ConversacionesClienteScreen> {
  late Future<List<SolicitudCliente>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = SolicitudService.getMisSolicitudes(widget.token);
  }

  void _reload() => setState(
      () => _futuro = SolicitudService.getMisSolicitudes(widget.token));

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
      body: FutureBuilder<List<SolicitudCliente>>(
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
                    'No tenés conversaciones aún',
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Contratá un profesional para empezar',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final s = lista[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ConversacionCard(
                    solicitud: s,
                    isDark: isDark,
                    onDetalle: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleSolicitudScreen(
                            token: widget.token,
                            solicitud: s,
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
                          proyectoId: s.id,
                          nombreProfesional: s.profesional,
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

class _ConversacionCard extends StatelessWidget {
  const _ConversacionCard({
    required this.solicitud,
    required this.isDark,
    required this.onDetalle,
    required this.onChat,
  });

  final SolicitudCliente solicitud;
  final bool isDark;
  final VoidCallback onDetalle;
  final VoidCallback onChat;

  Color get _estadoColor {
    switch (solicitud.estado) {
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
    switch (solicitud.estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'aceptado':
        return 'En progreso';
      case 'completado':
        return 'Completado';
      case 'rechazado':
        return 'Rechazado';
      default:
        return solicitud.estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final initial = solicitud.profesional.isNotEmpty
        ? solicitud.profesional[0].toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
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
            // ── Cabecera: avatar + nombre + estado ────────────────────
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
                        solicitud.profesional,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        solicitud.servicio,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF6366F1),
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

            // ── Precio + Fecha ─────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.attach_money_rounded,
                    size: 16, color: const Color(0xFF22C55E)),
                const SizedBox(width: 4),
                Text(
                  'Precio acordado: \$${solicitud.presupuesto.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const Spacer(),
                Icon(Icons.calendar_today_rounded,
                    size: 13, color: textSecondary),
                const SizedBox(width: 4),
                Text(
                  solicitud.fecha,
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Descripción ────────────────────────────────────────────
            if (solicitud.descripcion.isNotEmpty) ...[
              Text(
                solicitud.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
            ],

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
                    icon: const Icon(Icons.receipt_long_rounded, size: 15),
                    label: const Text('Ver cotización',
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
