import 'package:flutter/material.dart';

class WeatherAlertsSection extends StatelessWidget {
  final Map<String, dynamic>? currentWeather;

  const WeatherAlertsSection({
    required this.currentWeather,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'title': 'High UV Index',
        'message': 'UV index is very high today. Wear sunscreen.',
      },
      if (currentWeather?['weather'][0]['main'] == 'Rain')
        {
          'title': 'Rain Expected',
          'message': 'Rain is expected in your area today.',
        },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(alert['message']!),
            ],
          ),
        );
      },
    );
  }
}
