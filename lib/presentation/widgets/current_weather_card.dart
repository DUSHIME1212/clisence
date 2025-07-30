import 'package:clisence/presentation/widgets/weather_detail_card.dart';
import 'package:flutter/material.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;
  final IconData Function(String) getWeatherIcon;

  const CurrentWeatherCard({
    required this.weatherData,
    required this.getWeatherIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Weather',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherData?['name'] ?? 'Unknown Location',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${weatherData?['main']['temp']?.round()}°C',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weatherData?['weather'][0]['description'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Icon(
                  getWeatherIcon(weatherData?['weather'][0]['main'] ?? ''),
                  size: 64,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WeatherDetailCard(
                  label: 'High',
                  value: '${weatherData?['main']['temp_max']?.round()}°C',
                ),
                WeatherDetailCard(
                  label: 'Low',
                  value: '${weatherData?['main']['temp_min']?.round()}°C',
                ),
                WeatherDetailCard(
                  label: 'Humidity',
                  value: '${weatherData?['main']['humidity']}%',
                ),
                WeatherDetailCard(
                  label: 'Wind',
                  value: '${weatherData?['wind']['speed']?.round()} km/h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
