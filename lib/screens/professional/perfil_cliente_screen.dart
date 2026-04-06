import 'package:flutter/material.dart';
import 'package:pro_services/main.dart';
import 'package:pro_services/models/perfil_cliente_publico.dart';
import 'package:pro_services/services/perfil_cliente_service.dart';

class PerfilClienteScreen extends StatefulWidget {
  final String token;
  final int idCliente;

  const PerfilClienteScreen({
    super.key,
    required this.token,
    required this.idCliente,
  });

  @override
  State<PerfilClienteScreen> createState() => _PerfilClienteScreenState();
}

class _PerfilClienteScreenState extends State<PerfilClienteScreen> {
  late Future<PerfilClientePublico> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = PerfilClienteService.getPerfil(widget.token, widget.idCliente);
  }

  void _reload() {
    setState(() {
      _futuro = PerfilClienteService.getPerfil(widget.token, widget.idCliente);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : const Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Perfil del cliente',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color:
                  isDark ? const Color(0xFFFBBF24) : const Color(0xFF6366F1),
            ),
            onPressed: () => MyApp.of(context).toggleTheme(),
          ),
        ],
      ),
      body: FutureBuilder<PerfilClientePublico>(
        future: _futuro,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return _ErrorView(
              mensaje: snap.error.toString(),
              onReintentar: _reload,
            );
          }
          final perfil = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Tarjeta de perfil ───────────────────────────────────────
                _ProfileCard(
                  perfil: perfil,
                  isDark: isDark,
                  cardBg: cardBg,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 16),

                // ── Banner "Cliente frecuente" ───────────────────────────────
                if (perfil.calificacionPromedio >= 4.0)
                  _FrecuenteBanner(cardBg: cardBg),

                const SizedBox(height: 16),

                // ── Métricas ─────────────────────────────────────────────────
                _MetricasGrid(
                  perfil: perfil,
                  isDark: isDark,
                  cardBg: cardBg,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Tarjeta de perfil ─────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final PerfilClientePublico perfil;
  final bool isDark;
  final Color cardBg;
  final Color textPrimary;
  final Color textSecondary;

  const _ProfileCard({
    required this.perfil,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final inicial = perfil.nombre.isNotEmpty
        ? perfil.nombre[0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor:
                const Color(0xFF6366F1).withValues(alpha: 0.15),
            child: Text(
              inicial,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Nombre
          Text(
            perfil.nombre,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // Miembro desde
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 13, color: textSecondary),
              const SizedBox(width: 4),
              Text(
                'Miembro desde ${perfil.miembroDesde}',
                style: TextStyle(fontSize: 13, color: textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Banner cliente frecuente ──────────────────────────────────────────────────

class _FrecuenteBanner extends StatelessWidget {
  final Color cardBg;

  const _FrecuenteBanner({required this.cardBg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF22C55E).withValues(alpha: 0.35),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_rounded, color: Color(0xFF22C55E), size: 18),
          SizedBox(width: 8),
          Text(
            'Cliente frecuente ✓',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF22C55E),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grilla de métricas ────────────────────────────────────────────────────────

class _MetricasGrid extends StatelessWidget {
  final PerfilClientePublico perfil;
  final bool isDark;
  final Color cardBg;
  final Color textPrimary;
  final Color textSecondary;

  const _MetricasGrid({
    required this.perfil,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetricaTile(
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF22C55E),
          label: 'Proyectos completados',
          valor: '${perfil.proyectosCompletados}',
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 10),
        _MetricaTile(
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFFBBF24),
          label: 'Calificación promedio',
          valor: perfil.calificacionPromedio.toStringAsFixed(1),
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 10),
        _MetricaTile(
          icon: Icons.rate_review_rounded,
          iconColor: const Color(0xFF6366F1),
          label: 'Reseñas recibidas',
          valor: '${perfil.totalResenasRecibidas}',
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ],
    );
  }
}

class _MetricaTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String valor;
  final bool isDark;
  final Color cardBg;
  final Color textPrimary;
  final Color textSecondary;

  const _MetricaTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.valor,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: textSecondary),
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _ErrorView({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('Error al cargar el perfil'),
            const SizedBox(height: 8),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
