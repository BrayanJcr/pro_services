import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/slot_disponible.dart';
import '../../services/disponibilidad_service.dart';

class DisponibilidadProfesionalScreen extends StatefulWidget {
  final String token;
  final int idProfesional;
  final String nombreProfesional;

  const DisponibilidadProfesionalScreen({
    super.key,
    required this.token,
    required this.idProfesional,
    required this.nombreProfesional,
  });

  @override
  State<DisponibilidadProfesionalScreen> createState() =>
      _DisponibilidadProfesionalScreenState();
}

class _DisponibilidadProfesionalScreenState
    extends State<DisponibilidadProfesionalScreen> {
  late String _mesActual; // 'YYYY-MM'
  late Future<List<SlotDisponible>> _futuro;

  static const _acento = Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mesActual =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _cargarMes();
  }

  void _cargarMes() {
    _futuro = DisponibilidadService.getDisponibilidad(
      widget.token,
      widget.idProfesional,
      _mesActual,
    );
  }

  // ── Navegación de mes ────────────────────────────────────────────────────

  void _irMesAnterior() {
    final partes = _mesActual.split('-');
    var anio = int.parse(partes[0]);
    var mes = int.parse(partes[1]);
    mes--;
    if (mes < 1) {
      mes = 12;
      anio--;
    }
    setState(() {
      _mesActual = '$anio-${mes.toString().padLeft(2, '0')}';
      _cargarMes();
    });
  }

  void _irMesSiguiente() {
    final partes = _mesActual.split('-');
    var anio = int.parse(partes[0]);
    var mes = int.parse(partes[1]);
    mes++;
    if (mes > 12) {
      mes = 1;
      anio++;
    }
    setState(() {
      _mesActual = '$anio-${mes.toString().padLeft(2, '0')}';
      _cargarMes();
    });
  }

  // ── Helpers de fecha ─────────────────────────────────────────────────────

  String _labelMes() {
    const meses = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    final partes = _mesActual.split('-');
    final anio = partes[0];
    final mes = int.parse(partes[1]);
    return '${meses[mes]} $anio';
  }

  /// Retorna el día del mes como int de la fecha ISO 'YYYY-MM-DD'.
  int _diaDeSlot(String fecha) {
    return int.parse(fecha.split('-')[2]);
  }

  /// Primer día de la semana del mes actual (0=Dom, 1=Lun, ..., 6=Sáb).
  int _primerDiaSemana() {
    final partes = _mesActual.split('-');
    final dt = DateTime(int.parse(partes[0]), int.parse(partes[1]), 1);
    return dt.weekday % 7; // DateTime: 1=Lun..7=Dom → 0=Dom..6=Sáb
  }

  /// Cantidad de días del mes actual.
  int _diasEnMes() {
    final partes = _mesActual.split('-');
    final anio = int.parse(partes[0]);
    final mes = int.parse(partes[1]);
    return DateTime(anio, mes + 1, 0).day;
  }

  bool _esHoy(int dia) {
    final now = DateTime.now();
    final partes = _mesActual.split('-');
    return now.year == int.parse(partes[0]) &&
        now.month == int.parse(partes[1]) &&
        now.day == dia;
  }

  // ── Bottom Sheet de horarios ─────────────────────────────────────────────

  void _mostrarHorarios(
    BuildContext context,
    int dia,
    List<SlotDisponible> slots,
    bool isDark,
  ) {
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final bgModal = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);

    showModalBottomSheet(
      context: context,
      backgroundColor: bgModal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Horarios disponibles — día $dia',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...slots.map(
                (s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _acento.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: _acento,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${s.horaInicio} — ${s.horaFin}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disponibilidad',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              widget.nombreProfesional,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            ),
            onPressed: () => MyApp.of(context).toggleTheme(),
          ),
        ],
      ),
      body: FutureBuilder<List<SlotDisponible>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(
              mensaje: snapshot.error.toString(),
              onRetry: () => setState(_cargarMes),
            );
          }

          final slots = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _CalendarioCard(
                  isDark: isDark,
                  cardColor: cardColor,
                  labelMes: _labelMes(),
                  onAnterior: _irMesAnterior,
                  onSiguiente: _irMesSiguiente,
                  primerDiaSemana: _primerDiaSemana(),
                  diasEnMes: _diasEnMes(),
                  slots: slots,
                  esHoy: _esHoy,
                  diaDeSlot: _diaDeSlot,
                  onDiaTap: (dia, slotsDelDia) =>
                      _mostrarHorarios(context, dia, slotsDelDia, isDark),
                ),
                if (slots.isEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Sin slots registrados para este mes.',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Calendario ──────────────────────────────────────────────────────────────

class _CalendarioCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final String labelMes;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;
  final int primerDiaSemana;
  final int diasEnMes;
  final List<SlotDisponible> slots;
  final bool Function(int dia) esHoy;
  final int Function(String fecha) diaDeSlot;
  final void Function(int dia, List<SlotDisponible> slotsDelDia) onDiaTap;

  static const _acento = Color(0xFF6366F1);
  static const _diasSemana = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

  const _CalendarioCard({
    required this.isDark,
    required this.cardColor,
    required this.labelMes,
    required this.onAnterior,
    required this.onSiguiente,
    required this.primerDiaSemana,
    required this.diasEnMes,
    required this.slots,
    required this.esHoy,
    required this.diaDeSlot,
    required this.onDiaTap,
  });

  // Agrupa los slots por día del mes.
  Map<int, List<SlotDisponible>> _slotsPorDia() {
    final mapa = <int, List<SlotDisponible>>{};
    for (final s in slots) {
      if (s.fecha.isEmpty) continue;
      final dia = diaDeSlot(s.fecha);
      mapa.putIfAbsent(dia, () => []).add(s);
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    final mapa = _slotsPorDia();

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Navegación de mes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: onAnterior,
                color: _acento,
              ),
              Text(
                labelMes,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: onSiguiente,
                color: _acento,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Encabezado días de la semana
          Row(
            children: _diasSemana
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // Grid de días
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: primerDiaSemana + diasEnMes,
            itemBuilder: (context, index) {
              // Celdas vacías al inicio
              if (index < primerDiaSemana) {
                return const SizedBox.shrink();
              }

              final dia = index - primerDiaSemana + 1;
              final slotsDelDia = mapa[dia] ?? [];
              final tieneSlots = slotsDelDia.isNotEmpty;
              final hayDisponible = slotsDelDia.any((s) => s.disponible);
              final hoy = esHoy(dia);

              return _CeldaDia(
                dia: dia,
                isDark: isDark,
                tieneSlots: tieneSlots,
                hayDisponible: hayDisponible,
                esHoy: hoy,
                onTap: tieneSlots && hayDisponible
                    ? () => onDiaTap(
                          dia,
                          slotsDelDia.where((s) => s.disponible).toList(),
                        )
                    : null,
              );
            },
          ),
          const SizedBox(height: 16),

          // Leyenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LeyendaItem(
                color: _acento,
                label: 'Disponible',
                isDark: isDark,
              ),
              const SizedBox(width: 20),
              _LeyendaItem(
                color: Colors.grey,
                label: 'Ocupado',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Celda de día ────────────────────────────────────────────────────────────

class _CeldaDia extends StatelessWidget {
  final int dia;
  final bool isDark;
  final bool tieneSlots;
  final bool hayDisponible;
  final bool esHoy;
  final VoidCallback? onTap;

  static const _acento = Color(0xFF6366F1);

  const _CeldaDia({
    required this.dia,
    required this.isDark,
    required this.tieneSlots,
    required this.hayDisponible,
    required this.esHoy,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgCircle;
    Color textColor = isDark ? Colors.white70 : Colors.black87;

    if (hayDisponible) {
      bgCircle = _acento;
      textColor = Colors.white;
    } else if (tieneSlots) {
      bgCircle = Colors.grey[isDark ? 700 : 300];
      textColor = isDark ? Colors.white54 : Colors.black45;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgCircle,
          shape: BoxShape.circle,
          border: esHoy
              ? Border.all(
                  color: isDark ? Colors.white : Colors.black87,
                  width: 2,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$dia',
          style: TextStyle(
            fontSize: 13,
            fontWeight: esHoy ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

// ── Leyenda ─────────────────────────────────────────────────────────────────

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _LeyendaItem({
    required this.color,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    );
  }
}

// ── Error View ───────────────────────────────────────────────────────────────

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
          const Text('Error al cargar la disponibilidad'),
          const SizedBox(height: 8),
          Text(
            mensaje,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
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
