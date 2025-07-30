import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clisence/core/models/user_model.dart';
import 'package:clisence/core/providers/weather_provider.dart';
import 'package:clisence/core/services/gemini_service.dart';
import 'package:clisence/core/models/weather_model.dart';
import 'package:clisence/presentation/providers/auth_provider.dart';
import 'dart:math';

class CropAdviceScreen extends StatefulWidget {
  const CropAdviceScreen({Key? key}) : super(key: key);

  @override
  _CropAdviceScreenState createState() => _CropAdviceScreenState();
}

class _CropAdviceScreenState extends State<CropAdviceScreen> {
  final GeminiService _geminiService = GeminiService();
  bool _isLoading = true;
  bool _isGeminiLoading = false;
  String _aiAdvice = '';
  WeatherData? _weatherData;
  List<String> _userCrops = [];
  late WeatherProvider _weatherProvider;
  late AuthProvider _authProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      _isInitialized = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final user = _authProvider.user;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (user == null || user.district.isEmpty) {
        setState(() {
          _aiAdvice = 'Please complete your profile with location details';
          _isLoading = false;
        });
        return;
      }

      // Set user's crops and district
      setState(() {
        _userCrops = user.mainCrops ?? [];
      });

      // Get weather data
      await _weatherProvider.getWeatherData(user.district);

      if (mounted) {
        setState(() {
          _weatherData = _weatherProvider.weatherData;
        });

        // Get AI advice based on user's crops and location
        if (_weatherData != null) {
          await _getAIAdvice(user);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiAdvice = 'Error loading data: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getAIAdvice(UserModel? user) async {
    if (user == null) return;

    setState(() {
      _isGeminiLoading = true;
    });

    try {
      // Get AI response using the correct method
      final response = await _geminiService.getCropAdvice(
        rainfall: _weatherData?.dailyRain ?? 0.0,
        crops: _userCrops,
        temperature: _weatherData?.temperature ?? 0.0,
        humidity: _weatherData?.humidity ?? 0.0,
        location: '${user.region ?? ''}, ${user.country ?? ''}',
      );

      if (mounted) {
        setState(() {
          _aiAdvice = response;
          print('AI Advice Content: $_aiAdvice');
          _isGeminiLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiAdvice = 'Could not get AI advice. Error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeminiLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Advice'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Location',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('District: ${_authProvider.user?.district ?? 'Not set'}'),
                          Text('Region: ${_authProvider.user?.region ?? 'Not set'}'),
                          Text('Country: ${_authProvider.user?.country ?? 'Not set'}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User's Crops
                  const Text(
                    'Your Crops',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _userCrops.isEmpty
                      ? const Text('No crops added yet')
                      : Wrap(
                          spacing: 8.0,
                          children: _userCrops
                              .map(
                                (crop) => Chip(
                                  label: Text(crop),
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
                              )
                              .toList(),
                        ),

                  const SizedBox(height: 20),
                  // AI Advice
                  const Text(
                    'Adaptation Strategies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _isGeminiLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[100]!),
                          ),
                          child: Text(
                            _aiAdvice.isNotEmpty
                                ? _aiAdvice
                                : 'No advice available',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left,
                            maxLines: 20,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                  const SizedBox(height: 24),

                  // Additional Tips
                  const Text(
                    'General Tips for Current Conditions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildGeneralTips(),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildWeatherInfo() {
    if (_weatherData == null) return [];

    return [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Weather',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildWeatherInfoItem(
                    Icons.thermostat,
                    '${_weatherData!.temperature}°C',
                    'Temperature',
                  ),
                  _buildWeatherInfoItem(
                    Icons.water_drop,
                    '${_weatherData!.humidity}%',
                    'Humidity',
                  ),
                  _buildWeatherInfoItem(
                    Icons.water_drop,
                    '${_weatherData!.dailyRain}mm',
                    'Rainfall',
                  ),
                  _buildWeatherInfoItem(
                    Icons.air,
                    '${_weatherData!.windSpeed} km/h',
                    'Wind',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Last updated: ${_weatherData!.lastUpdated}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ];
  }

  Widget _buildWeatherInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildGeneralTips() {
    final tips = <String>[];

    if (_weatherData != null) {
      // Temperature-based tips
      if (_weatherData!.temperature > 30) {
        tips.add(
          '🌡️ Water your crops more frequently to prevent heat stress.',
        );
      } else if (_weatherData!.temperature < 10) {
        tips.add('❄️ Protect sensitive plants from potential frost damage.');
      }

      // Rainfall-based tips
      if (_weatherData!.dailyRain > 20) {
        tips.add('🌧️ Ensure proper drainage to prevent waterlogging.');
      } else if (_weatherData!.dailyRain < 5) {
        tips.add('💧 Consider additional irrigation as rainfall is low.');
      }

      // Wind-based tips
      if (_weatherData!.windSpeed > 20) {
        tips.add('💨 Stake tall plants to protect them from strong winds.');
      }
    }

    // Add some general tips if no specific ones were added
    if (tips.isEmpty) {
      tips.addAll([
        '🌱 Check soil moisture regularly and water as needed.',
        '🌿 Monitor for pests and diseases, especially in changing weather conditions.',
        '🌻 Consider crop rotation to maintain soil health.',
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tips
          .map(
            (tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 8),
                  Expanded(child: Text(tip)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
