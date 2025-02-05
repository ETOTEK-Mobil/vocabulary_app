import 'dart:convert';
import 'package:erva_vocubulary/models/random_model.dart';
import 'package:erva_vocubulary/services/routes/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RandomService {
  static Future<String> _getToken() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString('token') ?? '';
  }

  static Future<RandomModel?> fetchCardInfo() async {
    final token = await _getToken();
    final response = await http.get(
      ApiRoutes.random.uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print("API Yanıt Kodu: ${response.statusCode}");
    print("API Yanıtı: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final word = jsonDecode(response.body) as Map<String, dynamic>;
        return RandomModel.fromJson(word);
      } catch (e) {
        throw Exception("JSON dönüşüm hatası: $e");
      }
    } else {
      throw Exception('Veri alınamadı: ${response.body}');
    }
  }
}
