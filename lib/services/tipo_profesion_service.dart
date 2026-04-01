import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pro_services/models/tipo_profesion.dart';

class TipoProfesionService {
  static const _base = 'http://localhost:5099';

  static Future<List<TipoProfesion>> getTipos() async {
    final res = await http.get(Uri.parse('$_base/tipos-profesion'));
    _checkStatus(res);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => TipoProfesion.fromJson(e as Map<String, dynamic>)).toList();
  }

  static void _checkStatus(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }
}
