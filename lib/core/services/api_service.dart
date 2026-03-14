import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static String? currentUserId;
  static String? currentUsername;
  static bool hasCompletedAssessment = false;

  static Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('user_id');
    currentUsername = prefs.getString('username');
    hasCompletedAssessment = prefs.getBool('has_completed_assessment') ?? false;
    return currentUserId != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUserId = null;
    currentUsername = null;
    hasCompletedAssessment = false;
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "email": username,
        "password": password,
      }),
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(body?['message'] ?? 'Registration failed');
    }

    currentUserId = body['user_id'] ?? body['_id'];
    currentUsername = body['username'] ?? body['name'] ?? body['email'];
    hasCompletedAssessment = body['has_completed_assessment'] ?? false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', currentUserId!);
    await prefs.setString('username', currentUsername ?? '');
    await prefs.setBool('has_completed_assessment', hasCompletedAssessment);

    return Map<String, dynamic>.from(body as Map);
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "email": username,
        "password": password,
      }),
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode != 200) {
      throw Exception(body?['message'] ?? 'Login failed');
    }

    currentUserId = body['user_id'] ?? body['_id'];
    currentUsername = body['username'] ?? body['name'] ?? body['email'];
    hasCompletedAssessment = body['has_completed_assessment'] ?? false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', currentUserId!);
    await prefs.setString('username', currentUsername ?? '');
    await prefs.setBool('has_completed_assessment', hasCompletedAssessment);

    return Map<String, dynamic>.from(body as Map);
  }

  static Future<Map<String, dynamic>> submitAssessment(
    List<Map<String, dynamic>> answers,
  ) async {
    final url = Uri.parse('$_baseUrl/assessment/submit');
    if (currentUserId == null) {
      hasCompletedAssessment = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_completed_assessment', true);
      return {'status': 'success', 'has_completed_assessment': true};
    }

    final payload = {"user_id": currentUserId, "responses": answers};
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode != 200) {
      throw Exception(body?['message'] ?? 'Failed to submit assessment');
    }

    hasCompletedAssessment = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_assessment', true);

    return Map<String, dynamic>.from(body as Map);
  }
}
