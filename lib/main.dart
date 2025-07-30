import 'package:clisence/core/configs/theme/app_theme.dart';
import 'package:clisence/firebase_options.dart';
import 'package:clisence/presentation/pages/app/crop_advice_screen.dart';
import 'package:clisence/presentation/pages/app/home.dart';
import 'package:clisence/presentation/pages/app/settings.dart';
import 'package:clisence/presentation/pages/auth/farm_info_screen.dart';
import 'package:clisence/presentation/pages/auth/login.dart';
import 'package:clisence/presentation/providers/auth_provider.dart';
import 'package:clisence/presentation/providers/weather_provider.dart';
import 'package:clisence/presentation/widgets/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/crop-advice': (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: Provider.of<WeatherProvider>(context, listen: false),
                ),
                ChangeNotifierProvider.value(
                  value: Provider.of<AuthProvider>(context, listen: false),
                ),
              ],
              child: const CropAdviceScreen(),
            ),
        // Profile routes
        '/profile': (context) => const Scaffold(body: Center(child: Text('Profile - Coming Soon'))),
        '/farm-location': (context) => const FarmInfoScreen(
          userName: "",
          userEmail: "",
          userId: "",
        ),
        '/manage-crops': (context) => const Scaffold(body: Center(child: Text('Manage Crops - Coming Soon'))),
        // Preferences routes
        '/communication-preferences': (context) => const Scaffold(body: Center(child: Text('Communication Preferences - Coming Soon'))),
        '/language-settings': (context) => const Scaffold(body: Center(child: Text('Language Settings - Coming Soon'))),
        // Privacy routes
        '/privacy-settings': (context) => const Scaffold(body: Center(child: Text('Privacy Settings - Coming Soon'))),
        // Help routes
        '/contact-support': (context) => const Scaffold(body: Center(child: Text('Contact Support - Coming Soon'))),
        // Add other routes here
      },
    );
  }
}
