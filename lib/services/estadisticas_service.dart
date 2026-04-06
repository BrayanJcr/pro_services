import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pro_services/models/estadistica_precio.dart';

class EstadisticasService {
  static const _base = 'http://localhost:5099';

  static Future<EstadisticaPrecio?> getPrecioPromedio(
    String token, {
    int? tipoProfesionId,
    int? tipoServicioId,
  }) async {
    final params = <String, String>{};
    if (tipoProfesionId != null) {
      params['tipoProfesionId'] = tipoProfesionId.toString();
    }
    if (tipoServicioId != null) {
      params['tipoServicioId'] = tipoServicioId.toString();
    }

    final uri = Uri.parse('$_base/estadisticas/precio-promedio')
        .replace(queryParameters: params.isEmpty ? null : params);

    final res = await http.get(uri, headers: _headers(token));
    if (res.statusCode == 404) return null;
    _checkStatus(res);
    return EstadisticaPrecio.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>);
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
