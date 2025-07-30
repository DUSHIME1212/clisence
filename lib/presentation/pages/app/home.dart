import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:clisence/data/services/weather_service.dart';
import 'package:clisence/presentation/pages/app/settings.dart';
import 'package:clisence/presentation/pages/chat/chat_screen.dart';
import 'package:clisence/presentation/pages/app/profile_screen.dart';
import 'package:clisence/presentation/providers/auth_provider.dart';
import 'package:clisence/presentation/widgets/Basic_button.dart';
import 'package:clisence/presentation/widgets/current_weather_card.dart';
import 'package:clisence/presentation/widgets/hourly_forecast_section.dart';
import 'package:clisence/presentation/widgets/section_title.dart';
import 'package:clisence/presentation/widgets/weather_alerts_section.dart';
import 'package:clisence/presentation/widgets/weather_card.dart';
import 'package:clisence/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? currentWeather;
  List<dynamic>? hourlyForecast;
  List<dynamic>? dailyForecast;
  bool isLoading = true;
  String errorMessage = '';
  int _currentIndex = 0;

  // List of pages/screens to display based on the selected tab
  final List<Widget> _pages = [
    const Placeholder(), // Home/Weather screen
    const ChatScreen(),
    const ProfileScreen(), // Profile screen
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();

    // Show welcome message when user comes from login screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome ${authProvider.user?.email?.split('@')[0] ?? 'User'}!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  Future<void> _fetchWeatherData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final current = await WeatherService.getCurrentWeather();
      final hourly = await WeatherService.getHourlyForecast();

      setState(() {
        currentWeather = current;
        hourlyForecast = hourly;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load weather data: ${e.toString()}';
      });
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.grain;
      case 'Thunderstorm':
        return Icons.flash_on;
      case 'Snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('h a').format(date);
  }

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Prepare content based on loading state
    Widget content;

    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            ElevatedButton(
              onPressed: _fetchWeatherData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      // Process forecast data for the daily forecast cards
      final List<Map<String, dynamic>> forecasts = [
        {
          'title': 'Morning',
          'icon': _getWeatherIcon(currentWeather?['weather'][0]['main'] ?? ''),
          'description': currentWeather?['weather'][0]['description'] ?? '',
          'temperature': '${currentWeather?['main']['temp']?.round()}°C',
          'windSpeed':
          'Wind: ${currentWeather?['wind']['speed']?.round()} km/h',
          'image':
          'https://i.pinimg.com/736x/8b/55/59/8b5559aa155c458f774bccfade3c4782.jpg',
          'location': currentWeather?['name'] ?? '',
        },
        // Add more forecast periods as needed
      ];

      // Check if there are weather alerts
      final hasAlerts = currentWeather?['weather'][0]['main'] == 'Rain';

      content = RefreshIndicator(
        onRefresh: _fetchWeatherData,
        child: ListView(
          children: [
            // Current weather section
            CurrentWeatherCard(
              weatherData: currentWeather,
              getWeatherIcon: _getWeatherIcon,
            ),

            // Today's forecast section
            const SectionTitle(text: 'Today\'s Forecast'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: forecasts.length,
              itemBuilder: (context, index) {
                final forecast = forecasts[index];
                return WeatherCard(
                  title: forecast['title'],
                  iconData: forecast['icon'],
                  temperature: forecast['temperature'],
                  condition: forecast['description'],
                  imageUrl: forecast['image'],
                );
              },
            ),

            // Hourly forecast section
            const SectionTitle(text: 'Hourly Forecast'),
            HourlyForecastSection(
              hourlyForecast: hourlyForecast,
              getWeatherIcon: _getWeatherIcon,
              formatTime: _formatTime,
            ),

            // Weather alerts section (if any)
            if (hasAlerts) ...[
              const SectionTitle(text: 'Weather Alerts'),
              WeatherAlertsSection(currentWeather: currentWeather),
            ],

            // Actions section
            const SectionTitle(text: 'Actions'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BasicButton(
                logo: null,
                title: 'Go to Chat',
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _currentIndex == 0 ? content : _pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: BottomNavBar(
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}