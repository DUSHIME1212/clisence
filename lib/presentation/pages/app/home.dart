import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:clisence/core/services/weather_service.dart';
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

  final WeatherService _weatherService = WeatherService();

  Future<void> _fetchWeatherData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Use the user's location or a default location
      final location = 'Kigali'; // You might want to get this from user settings
      final weatherData = await _weatherService.fetchWeatherData(location);
      
      // Convert WeatherData to the format expected by the UI
      setState(() {
        currentWeather = {
          'main': {
            'temp': weatherData.temperature,
            'temp_min': weatherData.tempMin,
            'temp_max': weatherData.tempMax,
            'humidity': weatherData.humidity,
          },
          'weather': [
            {
              'main': weatherData.weatherCondition,
              'description': weatherData.weatherDescription,
              'icon': weatherData.iconCode,
            }
          ],
          'wind': {
            'speed': weatherData.windSpeed,
          },
          'dt': weatherData.lastUpdated.millisecondsSinceEpoch ~/ 1000,
          'name': location,
        };
        
        // For hourly forecast, you might want to implement a separate method in WeatherService
        hourlyForecast = []; // Set to empty for now
        
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchWeatherData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      content = SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current weather card
            CurrentWeatherCard(
              weatherData: currentWeather!,
              getWeatherIcon: _getWeatherIcon,
            ),
            
            const SizedBox(height: 24),
            
            // Crop Advice Card
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/crop-advice');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.eco, color: Colors.green, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get Crop Advice',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get personalized advice for your crops based on current weather',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Hourly forecast section
            const SectionTitle(text: 'Hourly Forecast'),
            HourlyForecastSection(
              hourlyForecast: hourlyForecast,
              getWeatherIcon: _getWeatherIcon,
              formatTime: _formatTime,
            ),
            
            const SizedBox(height: 24),
            
            // Weather alerts section
            const SectionTitle(text: 'Weather Alerts'),
            const SizedBox(height: 8),
            WeatherAlertsSection(currentWeather: currentWeather),
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