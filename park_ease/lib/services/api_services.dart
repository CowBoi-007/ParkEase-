import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/spot.dart';

// Update this every time you start ngrok for backend!
const String baseUrl = 'https://effervescible-enthusiastically-armandina.ngrok-free.dev';

class ApiService {
  static Future<List<Spot>> fetchAllSpots() async {
    final response = await http.get(Uri.parse('$baseUrl/api/spots'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Spot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load spots');
    }
  }

  static Future<Spot> fetchSpotById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/spots/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return Spot.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load spot');
    }
  }

  static Future<bool> assignSpot(String id) async {
    final response = await http.post(Uri.parse('$baseUrl/api/spots/$id/assign'));
    return response.statusCode == 200;
  }

  static Future<bool> freeSpot(String id) async {
    final response = await http.post(Uri.parse('$baseUrl/api/spots/$id/free'));
    return response.statusCode == 200;
  }

  /// Fix: Add this alias for backward compatibility with your screens.
  static Future<bool> releaseSpot(String id) => freeSpot(id);
}
