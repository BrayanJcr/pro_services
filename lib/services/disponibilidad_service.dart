import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/slot_disponible.dart';

class DisponibilidadService {
  static const _base = 'http://localhost:5099';

  /// Retorna los slots de disponibilidad de un profesional para un mes dado.
  /// [mes]: formato 'YYYY-MM'
  static Future<List<SlotDisponible>> getDisponibilidad(
    String token,
    int profesionalId,
    String mes,
  ) async {
    final uri = Uri.parse('$_base/api/HorarioProfesional/$profesionalId/disponibilidad')
        .replace(queryParameters: {'mes': mes});
    final res = await http.get(uri, headers: _headers(token));
    _checkStatus(res);
    final List<dynamic> data = jsonDecode(res.body) as List;
    return data
        .map((e) => SlotDisponible.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static void _checkStatus(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }
}
