import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:clisence/core/models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherService {
  // Using OpenWeatherMap API - you'll need to sign up for an API key at https://openweathermap.org/api
  static final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Fetches current weather data for a location
  Future<WeatherData> fetchWeatherData(String location) async {
    try {
      // First, get coordinates for the location
      final geoResponse = await http.get(
        Uri.parse('http://api.openweathermap.org/geo/1.0/direct?q=$location&limit=1&appid=$_apiKey'),
      );

      if (geoResponse.statusCode != 200) {
        throw Exception('Failed to get location data: ${geoResponse.statusCode}');
      }

      final List<dynamic> locationData = jsonDecode(geoResponse.body);
      if (locationData.isEmpty) {
        throw Exception('Location not found');
      }

      final double lat = locationData[0]['lat'];
      final double lon = locationData[0]['lon'];

      // Get weather data using coordinates
      final response = await http.get(
        Uri.parse('$_baseUrl/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&units=metric&appid=$_apiKey'),
      );

      if (response.statusCode == 200) {
        return _parseWeatherData(response.body, location);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return _getMockWeatherData(location);
    }
  }

  /// Parses the raw weather API response into a WeatherData object
  WeatherData _parseWeatherData(String responseBody, String location) {
    final json = jsonDecode(responseBody);
    final current = json['current'];
    final daily = json['daily'][0]; // Today's forecast

    return WeatherData(
      location: location,
      temperature: current['temp'].toDouble(),
      feelsLike: current['feels_like'].toDouble(),
      humidity: current['humidity'].toDouble(),
      windSpeed: (current['wind_speed'] * 3.6).toDouble(), // Convert m/s to km/h
      windDirection: current['wind_deg'].toDouble(),
      pressure: current['pressure'].toDouble(),
      weatherCondition: current['weather'][0]['main'],
      weatherDescription: current['weather'][0]['description'],
      iconCode: current['weather'][0]['icon'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(current['sunrise'] * 1000, isUtc: true).toLocal(),
      sunset: DateTime.fromMillisecondsSinceEpoch(current['sunset'] * 1000, isUtc: true).toLocal(),
      cloudiness: current['clouds'].toDouble(),
      visibility: (current['visibility'] / 1000).toDouble(), // Convert meters to km
      uvIndex: current['uvi']?.toDouble() ?? 0,
      rainLastHour: current['rain']?['1h']?.toDouble() ?? 0,
      snowLastHour: current['snow']?['1h']?.toDouble() ?? 0,
      dailyRain: (daily['rain'] ?? 0).toDouble(),
      dailySnow: (daily['snow'] ?? 0).toDouble(),
      tempMin: daily['temp']['min'].toDouble(),
      tempMax: daily['temp']['max'].toDouble(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Returns mock weather data for demonstration purposes
  WeatherData _getMockWeatherData(String location) {
    final now = DateTime.now();
    return WeatherData(
      location: location,
      temperature: 25.0,
      feelsLike: 26.5,
      humidity: 65.0,
      windSpeed: 12.0,
      windDirection: 180.0,
      pressure: 1013.0,
      weatherCondition: 'Clouds',
      weatherDescription: 'scattered clouds',
      iconCode: '03d',
      sunrise: DateTime(now.year, now.month, now.day, 6, 30),
      sunset: DateTime(now.year, now.month, now.day, 18, 30),
      cloudiness: 40.0,
      visibility: 10.0,
      uvIndex: 7.5,
      rainLastHour: 0.0,
      snowLastHour: 0.0,
      dailyRain: 0.0,
      dailySnow: 0.0,
      tempMin: 20.0,
      tempMax: 28.0,
      lastUpdated: now,
    );
  }
}
