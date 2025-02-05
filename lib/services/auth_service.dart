import 'dart:convert';

import 'package:erva_vocubulary/services/routes/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> _setToken(String token) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString('token', token);
  }

  static Future<bool> loggedIn() async {
    final instance = await SharedPreferences.getInstance();
    return instance.containsKey('token');
  }

  Future<void> logout() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove('token');
  }

  static Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        ApiRoutes.login.uri,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'] as String;
        await _setToken(token);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Hata oluştu';
        throw Exception('Login failed: $error');
      }
    } catch (e) {
      throw Exception('An error occurred during login: $e');
    }
  }

  static Future<void> register(
      String username, String password, String email) async {
    try {
      final response = await http.post(
        ApiRoutes.register.uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      print("API Yanıtı: ${response.body}");
      print("API Yanıt Kodu: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'] as String;
        final message = responseBody['message'] as String;

        if (message == 'User created successfully') {
          await _setToken(token);
        } else {
          throw Exception('Kayıt başarısız: $message');
        }
      }
    } catch (e) {
      throw Exception('Kayıt sırasında hata oluştu: $e');
    }
  }
}
