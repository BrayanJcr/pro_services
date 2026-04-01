import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoritoService {
  static const String _base = 'http://localhost:5099';

  static Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static void _checkStatus(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }

  static Future<Set<int>> getIdsFavoritos(String token) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/favoritos'),
        headers: _headers(token),
      );
      _checkStatus(res);
      final list = jsonDecode(res.body) as List;
      return list.map((j) => j['idProfesional'] as int).toSet();
    } catch (_) {
      return {};
    }
  }

  static Future<void> agregar(String token, int idProfesional) async {
    final res = await http.post(
      Uri.parse('$_base/favoritos'),
      headers: _headers(token),
      body: jsonEncode({'idProfesional': idProfesional}),
    );
    // 409 Conflict = ya existe, no es error
    if (res.statusCode != 409) _checkStatus(res);
  }

  static Future<void> quitar(String token, int idProfesional) async {
    final res = await http.delete(
      Uri.parse('$_base/favoritos/$idProfesional'),
      headers: _headers(token),
    );
    _checkStatus(res);
  }
}
