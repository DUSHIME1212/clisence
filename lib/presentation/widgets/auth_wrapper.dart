import 'package:clisence/presentation/pages/app/home.dart';
import 'package:clisence/presentation/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/pages/auth/login.dart';
import '../../presentation/providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    print("AuthWrapper rebuild - isAuthenticated: ${authProvider.isAuthenticated}");
    print("Current user: ${authProvider.user?.email}");


    return authProvider.isAuthenticated
        ? const HomeScreen()
        : const SplashScreen();
  }
}
