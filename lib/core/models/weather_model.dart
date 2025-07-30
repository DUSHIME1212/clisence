import 'package:flutter/material.dart';

/// Represents weather data for a specific location and time
class WeatherData {
  final String location;
  final double temperature; // in Celsius
  final double feelsLike; // in Celsius
  final double humidity; // in percentage
  final double windSpeed; // in km/h
  final double windDirection; // in degrees
  final double pressure; // in hPa
  final String weatherCondition; // e.g., 'Clear', 'Rain', 'Clouds'
  final String weatherDescription; // e.g., 'light rain', 'scattered clouds'
  final String iconCode; // Weather icon code from the API
  final DateTime sunrise;
  final DateTime sunset;
  final double cloudiness; // in percentage
  final double visibility; // in kilometers
  final double uvIndex;
  final double rainLastHour; // in mm
  final double snowLastHour; // in mm
  final double dailyRain; // in mm
  final double dailySnow; // in mm
  final double tempMin; // in Celsius
  final double tempMax; // in Celsius
  final DateTime lastUpdated;

  /// Returns the appropriate weather icon based on the icon code
  IconData get weatherIcon {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny;
      case '01n':
        return Icons.nightlight_round;
      case '02d':
      case '03d':
      case '04d':
        return Icons.wb_cloudy;
      case '02n':
      case '03n':
      case '04n':
        return Icons.cloud;
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return Icons.grain;
      case '11d':
      case '11n':
        return Icons.flash_on;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.blur_on;
      default:
        return Icons.help_outline;
    }
  }

  /// Returns a color based on temperature
  Color get temperatureColor {
    if (temperature < 0) {
      return Colors.blue[900]!; // Very cold
    } else if (temperature < 10) {
      return Colors.blue[400]!; // Cold
    } else if (temperature < 20) {
      return Colors.lightBlue[200]!; // Cool
    } else if (temperature < 30) {
      return Colors.green[400]!; // Pleasant
    } else if (temperature < 35) {
      return Colors.orange[400]!; // Warm
    } else {
      return Colors.red[700]!; // Hot
    }
  }

  /// Returns a formatted time string
  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Returns a formatted date string
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  const WeatherData({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.weatherCondition,
    required this.weatherDescription,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
    required this.cloudiness,
    required this.visibility,
    required this.uvIndex,
    required this.rainLastHour,
    required this.snowLastHour,
    required this.dailyRain,
    required this.dailySnow,
    required this.tempMin,
    required this.tempMax,
    required this.lastUpdated,
  });

  /// Creates a copy of this WeatherData with the given fields replaced with the new values
  WeatherData copyWith({
    String? location,
    double? temperature,
    double? feelsLike,
    double? humidity,
    double? windSpeed,
    double? windDirection,
    double? pressure,
    String? weatherCondition,
    String? weatherDescription,
    String? iconCode,
    DateTime? sunrise,
    DateTime? sunset,
    double? cloudiness,
    double? visibility,
    double? uvIndex,
    double? rainLastHour,
    double? snowLastHour,
    double? dailyRain,
    double? dailySnow,
    double? tempMin,
    double? tempMax,
    DateTime? lastUpdated,
  }) {
    return WeatherData(
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      pressure: pressure ?? this.pressure,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherDescription: weatherDescription ?? this.weatherDescription,
      iconCode: iconCode ?? this.iconCode,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      cloudiness: cloudiness ?? this.cloudiness,
      visibility: visibility ?? this.visibility,
      uvIndex: uvIndex ?? this.uvIndex,
      rainLastHour: rainLastHour ?? this.rainLastHour,
      snowLastHour: snowLastHour ?? this.snowLastHour,
      dailyRain: dailyRain ?? this.dailyRain,
      dailySnow: dailySnow ?? this.dailySnow,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
