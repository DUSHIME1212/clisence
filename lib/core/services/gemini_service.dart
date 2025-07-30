import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY']!;
  late final GenerativeModel _model;
  bool _isInitialized = false;

  GeminiService() {
    _initialize();
  }

  void _initialize() {
    try {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash-001',
        apiKey: _apiKey,
      );
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      print('Failed to initialize Gemini: $e');
    }
  }

  Future<String> getCropAdvice({
    required List<String> crops,
    required double temperature,
    required double humidity,
    required double rainfall,
    required String location,
  }) async {
    if (!_isInitialized) {
      print('Error: Gemini service not initialized');
      return 'Error: AI service is not properly initialized.';
    }

    try {
      final prompt = _buildPrompt(
        crops: crops,
        temperature: temperature,
        humidity: humidity,
        rainfall: rainfall,
        location: location,
      );

      print('Sending prompt to Gemini API...');
      print('Prompt length: ${prompt.length} characters');
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content)
          .timeout(const Duration(seconds: 30), onTimeout: () {
        print('Gemini API request timed out');
        throw TimeoutException('The request timed out');
      });

      print('Received response from Gemini API');
      print('Response type: ${response.runtimeType}');
      print('Response text: ${response.text}');
      print('Response candidates: ${response.candidates}');
      
      if (response.text == null) {
        print('No text in response. Full response: $response');
        return 'No advice could be generated at this time. Please try again.';
      }
      
      return response.text!;
    } on TimeoutException {
      print('Gemini API request timed out');
      return 'Request timed out. Please check your internet connection and try again.';
    } catch (e) {
      print('Error generating crop advice: $e');
      print('Error type: ${e.runtimeType}');
      return 'Sorry, I encountered an error while generating advice. Please try again later.';
    }
  }

  String _buildPrompt({
    required List<String> crops,
    required double temperature,
    required double humidity,
    required double rainfall,
    required String location,
  }) {
    return '''
    You are an expert agricultural advisor providing specific, actionable advice to farmers.
    
    **Current Conditions:**
    - Location: $location
    - Temperature: ${temperature.toStringAsFixed(1)}°C
    - Humidity: ${humidity.toStringAsFixed(1)}%
    - Rainfall: ${rainfall.toStringAsFixed(1)}mm (recent period)
    
    **Farmer's Crops:**
    ${crops.map((crop) => '- $crop').join('\n')}
    
    Please provide specific adaptation strategies for these crops given the current conditions. Include:
    1. Immediate actions the farmer should take
    2. Potential risks to watch out for
    3. Recommended timing for next steps
    4. Any specific varieties or practices that would be beneficial
    
    Keep the advice practical, localized, and easy to understand. Focus on low-cost, high-impact recommendations.
    
    Format the response in clear, concise bullet points with emojis for better readability.
    ''';
  }
}