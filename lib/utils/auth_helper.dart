import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthHelper {
  /// Handles Firebase auth errors and provides user-friendly messages
  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid login credentials.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        if (kDebugMode) {
          print('Firebase Auth Error: ${e.code} - ${e.message}');
        }
        return 'An error occurred during authentication.';
    }
  }

  /// Handles reCAPTCHA token issues in Firebase Auth
  static void handleRecaptchaIssue(dynamic error) {
    if (error.toString().contains('reCAPTCHA')) {
      if (kDebugMode) {
        print('reCAPTCHA token is empty or invalid. This is expected in debug mode.');
        print('In production, ensure proper reCAPTCHA configuration.');
      }
    }
  }
}
