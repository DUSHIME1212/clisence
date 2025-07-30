import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String temperature;
  final String condition;
  final String imageUrl;

  const WeatherCard({
    required this.title,
    required this.iconData,
    required this.temperature,
    required this.condition,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(iconData, size: 32, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(condition),
                Text(
                  temperature,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Image.network(
              imageUrl,
              height: 72,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ],
        ),
      ),
    );
  }
}
