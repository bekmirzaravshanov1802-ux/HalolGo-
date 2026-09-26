import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // Hostingga joylashtirgandan keyin shu manzilni almashtiring.
  static const String baseUrl = 'https://YOUR-HALOLGO-SERVER.example.com';

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<Map<String, dynamic>> login(
      String phone, String password) async {
    final r = await http.post(
      _uri('/api/customers/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    if (r.statusCode >= 400) {
      throw Exception(_error(r.body));
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> register(
      String name, String phone, String password) async {
    final r = await http.post(
      _uri('/api/customers/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'password': password,
      }),
    );
    if (r.statusCode >= 400) {
      throw Exception(_error(r.body));
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> orders(int userId) async {
    final r = await http.get(_uri('/api/orders?uid=$userId'));
    if (r.statusCode >= 400) throw Exception(_error(r.body));
    return jsonDecode(r.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> customer(int id) async {
    final r = await http.get(_uri('/api/customers/$id'));
    if (r.statusCode >= 400) throw Exception(_error(r.body));
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> chat(int userId, String name) async {
    final r = await http.get(
      _uri('/api/chats/customer:$userId?name=${Uri.encodeComponent(name)}'),
    );
    if (r.statusCode >= 400) throw Exception(_error(r.body));
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> sendMessage(
      int userId, String from, String text) async {
    final r = await http.post(
      _uri('/api/chats/customer:$userId/messages'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'from': from, 'text': text}),
    );
    if (r.statusCode >= 400) throw Exception(_error(r.body));
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static String _error(String body) {
    try {
      return (jsonDecode(body)['error'] ?? 'Server xatosi').toString();
    } catch (_) {
      return 'Server xatosi';
    }
  }
}
