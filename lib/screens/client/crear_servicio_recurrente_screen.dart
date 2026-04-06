import 'package:flutter/material.dart';
import 'package:pro_services/main.dart';
import 'package:pro_services/services/servicio_recurrente_service.dart';

class CrearServicioRecurrenteScreen extends StatefulWidget {
  final String token;

  const CrearServicioRecurrenteScreen({super.key, required this.token});

  @override
  State<CrearServicioRecurrenteScreen> createState() =>
      _CrearServicioRecurrenteScreenState();
}

class _CrearServicioRecurrenteScreenState
    extends State<CrearServicioRecurrenteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionCtrl = TextEditingController();

  String _frecuencia = 'mensual';
  int? _diaSemana; // 1=Lunes … 7=Domingo
  TimeOfDay? _horaInicio;
  DateTime? _fechaInicio;
  bool _guardando = false;

  static const _frecuencias = ['semanal', 'quincenal', 'mensual'];
  static const _diasSemana = [
    (1, 'Lunes'),
    (2, 'Martes'),
    (3, 'Miércoles'),
    (4, 'Jueves'),
    (5, 'Viernes'),
    (6, 'Sábado'),
    (7, 'Domingo'),
  ];

  bool get _requiereDia => _frecuencia == 'semanal' || _frecuencia == 'quincenal';

  @override
  void dispose() {
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaInicio ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _horaInicio = picked);
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _fechaInicio = picked);
  }

  Future<void> _crear() async {
    if (!_formKey.currentState!.validate()) return;
    if (_horaInicio == null) {
      _showSnack('Seleccioná la hora de inicio', error: true);
      return;
    }
    if (_fechaInicio == null) {
      _showSnack('Seleccioná la fecha de inicio', error: true);
      return;
    }
    if (_requiereDia && _diaSemana == null) {
      _showSnack('Seleccioná el día de la semana', error: true);
      return;
    }

    setState(() => _guardando = true);
    try {
      final horaStr =
          '${_horaInicio!.hour.toString().padLeft(2, '0')}:${_horaInicio!.minute.toString().padLeft(2, '0')}';
      final fechaStr =
          '${_fechaInicio!.year}-${_fechaInicio!.month.toString().padLeft(2, '0')}-${_fechaInicio!.day.toString().padLeft(2, '0')}';

      final body = <String, dynamic>{
        'idUsuario': 0, // hardcodeado — sin parser JWT por ahora
        'idProfesional': 0,
        'descripcion': _descripcionCtrl.text.trim(),
        'frecuencia': _frecuencia,
        'horaInicio': horaStr,
        'fechaInicio': fechaStr,
        'usuarioCreacion': 'cliente',
        if (_requiereDia && _diaSemana != null) 'diaSemana': _diaSemana,
      };

      await ServicioRecurrenteService.crear(widget.token, body);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Error al crear: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _showSnack(String msg, {bool error = false}) {
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
    final labelColor =
        isDark ? Colors.grey.shade300 : const Color(0xFF374151);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        title: const Text(
          'Nuevo servicio recurrente',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Descripción ─────────────────────────────────────────────
              Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600, color: labelColor)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describí el servicio recurrente...',
                  filled: true,
                  fillColor: cardColor,
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'La descripción es obligatoria' : null,
              ),
              const SizedBox(height: 20),

              // ── Frecuencia ───────────────────────────────────────────────
              Text('Frecuencia', style: TextStyle(fontWeight: FontWeight.w600, color: labelColor)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _frecuencia,
                    isExpanded: true,
                    items: _frecuencias
                        .map((f) => DropdownMenuItem(
                              value: f,
                              child: Text(
                                f[0].toUpperCase() + f.substring(1),
                                style: TextStyle(color: labelColor),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _frecuencia = v;
                        if (v == 'mensual') _diaSemana = null;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Día de la semana (solo si semanal o quincenal) ───────────
              if (_requiereDia) ...[
                Text('Día de la semana',
                    style: TextStyle(fontWeight: FontWeight.w600, color: labelColor)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _diaSemana,
                      isExpanded: true,
                      hint: Text('Seleccioná un día',
                          style: TextStyle(color: Colors.grey.shade500)),
                      items: _diasSemana
                          .map((d) => DropdownMenuItem(
                                value: d.$1,
                                child: Text(d.$2,
                                    style: TextStyle(color: labelColor)),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _diaSemana = v),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── Hora de inicio ───────────────────────────────────────────
              Text('Hora de inicio',
                  style: TextStyle(fontWeight: FontWeight.w600, color: labelColor)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _seleccionarHora,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: Color(0xFF6366F1), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        _horaInicio != null
                            ? _horaInicio!.format(context)
                            : 'Seleccioná la hora',
                        style: TextStyle(
                          color: _horaInicio != null
                              ? labelColor
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Fecha de inicio ──────────────────────────────────────────
              Text('Fecha de inicio',
                  style: TextStyle(fontWeight: FontWeight.w600, color: labelColor)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _seleccionarFecha,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: Color(0xFF6366F1), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        _fechaInicio != null
                            ? '${_fechaInicio!.day.toString().padLeft(2, '0')}/${_fechaInicio!.month.toString().padLeft(2, '0')}/${_fechaInicio!.year}'
                            : 'Seleccioná la fecha',
                        style: TextStyle(
                          color: _fechaInicio != null
                              ? labelColor
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Botón crear ──────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: _guardando ? null : _crear,
                  child: _guardando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Crear servicio recurrente',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
