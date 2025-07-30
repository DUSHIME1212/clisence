import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:clisence/core/models/weather_model.dart';
import 'package:clisence/core/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetches weather data for a specific location
  Future<void> getWeatherData(String location) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weatherData = await _weatherService.fetchWeatherData(location);
      _error = null;
    } catch (e) {
      _error = 'Failed to load weather data: ${e.toString()}';
      if (kDebugMode) {
        print('Weather data fetch error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes the weather data
  Future<void> refreshWeatherData(String location) async {
    await getWeatherData(location);
  }

  /// Clears all weather data
  void clearWeatherData() {
    _weatherData = null;
    _error = null;
    notifyListeners();
  }
}
