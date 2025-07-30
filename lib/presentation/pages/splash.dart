import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:clisence/presentation/pages/intro/getstarted.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Getstarted()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: Image.asset("/assets/vectors/logo.png",
            height: 100,
            width: double.infinity,

        ),
      ),
    );
  }
}
