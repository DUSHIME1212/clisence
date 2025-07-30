import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:clisence/utils/auth_helper.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _error;
  bool _isLoading = false;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize auth state
  AuthProvider() {
    _initAuth();
  }

  // Initialize auth state listener
  void _initAuth() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print("User logged in: ${user.email} (ID: ${user.uid})");
      } else {
        print("User logged out");
      }
      _user = user;
      notifyListeners();
    });
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _error = 'Email and password cannot be empty';
      notifyListeners();
      return null;
    }

    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      return await _auth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Authentication timed out');
        },
      );
    } on FirebaseAuthException catch (e) {
      _error = AuthHelper.getErrorMessage(e);
      return null;
    } catch (e) {
      _error = 'An unexpected error occurred';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      _isLoading = false;
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = AuthHelper.getErrorMessage(e);
      AuthHelper.handleRecaptchaIssue(e);
      notifyListeners();
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = 'Error signing out';
      notifyListeners();
    }
  }

}