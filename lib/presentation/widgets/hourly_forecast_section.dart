import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyForecastSection extends StatelessWidget {
  final List<dynamic>? hourlyForecast;
  final IconData Function(String) getWeatherIcon;
  final String Function(int) formatTime;

  const HourlyForecastSection({
    required this.hourlyForecast,
    required this.getWeatherIcon,
    required this.formatTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyForecast == null || hourlyForecast!.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('No hourly data available')),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyForecast!.length,
        itemBuilder: (context, index) {
          final forecast = hourlyForecast![index];
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formatTime(forecast['dt'])),
                const SizedBox(height: 8),
                Icon(
                  getWeatherIcon(forecast['weather'][0]['main']),
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text('${forecast['main']['temp']?.round()}°C'),
              ],
            ),
          );
        },
      ),
    );
  }
}
