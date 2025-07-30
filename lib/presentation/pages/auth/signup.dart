import 'package:clisence/presentation/pages/auth/farm_info_screen.dart';
import 'package:clisence/presentation/pages/auth/login.dart';
import 'package:clisence/presentation/widgets/Basic_button.dart';
import 'package:clisence/presentation/widgets/Basic_input.dart';
import 'package:clisence/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';
// Assuming FarmInfoScreen is in this file

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      }
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userCredential = await authProvider.signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (authProvider.error != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authProvider.error!)));
    } else if (userCredential?.user != null && context.mounted) {
      // Navigate to FarmInfoScreen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FarmInfoScreen(
            userId: userCredential!.user!.uid,
            userName: _nameController.text.trim(),
            userEmail: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: BackgroundImage()),
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Create an account to get weather updates and information",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    BasicInput(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
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
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
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
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    BasicInput(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      obscureText: _obscureConfirmPassword,
                      showPasswordToggle: true,
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                      onPasswordToggle: (isObscured) {
                        setState(() {
                          _obscureConfirmPassword = isObscured;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _signUp(),
                    ),
                    const SizedBox(height: 24),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : BasicButton(
                                callback: _signUp,
                                title: "Create Account",
                                logo: null,
                              );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Center(child: Text("or")),
                    const SizedBox(height: 16),
                    BasicButton(
                      logo: Image.asset(
                        'assets/images/devicon_google.png',
                        width: 24,
                        height: 24,
                      ),
                      callback: () {},
                      title: "Signup with Google",
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const Text(
                        'already have an account? Sign in',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget BackgroundImage() {
  return ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: [Colors.green.shade900, Colors.green.shade300],
      begin: Alignment.bottomCenter,
      end: Alignment.center,
      stops: const [0.1, 0.9],
      tileMode: TileMode.clamp,
    ).createShader(bounds),
    blendMode: BlendMode.multiply,
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/vectors/onboard/1.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
    ),
  );
}
