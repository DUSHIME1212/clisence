import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:clisence/core/configs/theme/app_theme.dart';
import 'package:clisence/presentation/pages/app/home.dart';
import 'package:clisence/presentation/pages/auth/signup.dart';
import 'package:clisence/presentation/widgets/Basic_button.dart';
import 'package:clisence/presentation/widgets/app_bar.dart';
import 'package:clisence/presentation/widgets/basic_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!context.mounted) return;

    if (authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error!))
      );
    } else if (result != null) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!'))
      );

      // Navigate to home screen and remove the login screen from the stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Clisence is app for get weather updates and information",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      // Email Input
                      BasicInput(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      // Password Input
                      BasicInput(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        obscureText: _obscurePassword,
                        showPasswordToggle: true,
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        onPasswordToggle: (isObscured) {
                          setState(() {
                            _obscurePassword = isObscured;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(),
                      ),
                      const SizedBox(height: 16),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return authProvider.isLoading
                              ? const Center(child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                              ))
                              : BasicButton(
                                  callback: _login,
                                  title: "Login with Email",
                                  logo: null,
                                );
                        },
                      ),
                      const SizedBox(height: 12),
                      const Center(child: Text("or")),
                      const SizedBox(height: 12),
                      BasicButton(
                        callback: () {},
                        title: "Login with Google",
                        logo: Image.asset(
                          'assets/images/devicon_google.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Signup()),
                          );
                        },
                        child: const Text(
                          'Don\'t have an account? Sign up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
