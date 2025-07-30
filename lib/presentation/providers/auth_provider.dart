import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:clisence/utils/auth_helper.dart';

import '../../core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _firebaseUser;
  UserModel? _userModel;
  String? _error;
  bool _isLoading = false;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null;

  // Initialize auth state
  AuthProvider() {
    _initAuth();
  }

  // Initialize auth state listener
  void _initAuth() {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        print("User logged in: ${user.email} (ID: ${user.uid})");
        
        try {
          // Load user data from Firestore
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (doc.exists) {
            _userModel = UserModel.fromMap(doc.data()!);
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'id': user.uid,
              'email': user.email,
              'fullName': user.displayName ?? 'User',
              'phone': user.phoneNumber ?? '',
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
              'gender': '',
              'age': 0,
              'country': '',
              'region': '',
              'district': '',
              'farmSize': 0.0,
              'mainCrops': [],
              'plantingSeason': '',
              'preferredChannels': [],
            });
            

            final newDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
                
            _userModel = UserModel.fromMap(newDoc.data()!);
          }
        } catch (e) {
          print('Error loading user data: $e');
          _userModel = UserModel(
            id: user.uid,
            fullName: user.displayName ?? 'User',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            gender: '',
            age: 0,
            country: '',
            region: '',
            district: '',
            farmSize: 0.0,
            mainCrops: const [],
            plantingSeason: '',
            preferredChannels: const [],
          );
        }
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  // Update user data
  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Update local user model
      _userModel = updatedUser;

      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.id) // Use the user's ID as the document ID
          .set(
        updatedUser.toJson(), // Convert user model to map
        SetOptions(merge: true), // Merge with existing document if it exists
      );

      print('User data updated in Firestore: ${updatedUser.toJson()}');
    } catch (e) {
      _error = 'Failed to update user data: $e';
      print('Error updating user data: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
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

      return await _auth
          .signInWithEmailAndPassword(
            email: trimmedEmail,
            password: trimmedPassword,
          )
          .timeout(
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
    String email,
    String password,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update the user's display name if provided
      // if (displayName != null && displayName.isNotEmpty) {
      //   await userCredential.user?.updateDisplayName(displayName);
      //   // Update the local user reference
      //   _user = _auth.currentUser;
      // }

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

  // Delete user account
  Future<void> deleteUser() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      // Delete user data from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete user from Firebase Auth
      await user.delete();

      // Clear local state
      _firebaseUser = null;
      _userModel = null;
      
    } on FirebaseAuthException catch (e) {
      _error = 'Failed to delete account: ${e.message}';
      rethrow;
    } on Exception catch (e) {
      _error = 'An error occurred: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userModel = null;
      notifyListeners();
    } catch (e) {
      _error = 'Error signing out';
      notifyListeners();
    }
  }
}
