import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static final String? _apiKey = dotenv.env['OPENWEATHER_API_KEY'];

  // Fixed coordinates for Rwanda (Kigali)
  static const Map<String, double> _rwandaLocation = {
    'latitude': -1.9396,
    'longitude': 30.0444,
  };

  static Future<Map<String, dynamic>> getCurrentWeather() async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?'
          'lat=${_rwandaLocation['latitude']}&lon=${_rwandaLocation['longitude']}&'
          'appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> getHourlyForecast() async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?'
          'lat=${_rwandaLocation['latitude']}&lon=${_rwandaLocation['longitude']}&'
          'appid=$_apiKey&units=metric&cnt=5',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['list'];
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
  }
}