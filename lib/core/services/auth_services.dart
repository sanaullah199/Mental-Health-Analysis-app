import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mental_health_analysis_app/core/models/user_model.dart';
import 'package:mental_health_analysis_app/core/services/auth_exception_service.dart';

import 'package:mental_health_analysis_app/core/services/database_services.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseServices _databaseServices = DatabaseServices();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Register with Namae, Email & Password
  Future<User?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        final newUser = UserModel(
          uuid: user.uid,
          name: name,
          email: email,
          profileImage: "",
        );
        await _databaseServices.createUser(newUser);

        _showSnackbar("Registration Successful", "Welcome, $name!");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthExceptionsService.generateExceptionMessage(e);
      _showSnackbar("Error", errorMessage, isError: true);
      return null;
    } catch (e) {
      _showSnackbar(
        "Error",
        "Something went wrong. Please try again.",
        isError: true,
      );
      return null;
    }
  }

  // Login with Email & Password
  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      if (user != null) {
        _showSnackbar("Welcome Back!", "You’re successfully logged in.");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthExceptionsService.generateExceptionMessage(e);
      _showSnackbar("Login Failed", errorMessage, isError: true);
      return null;
    } catch (e) {
      _showSnackbar(
        "Error",
        "Something went wrong. Please try again.",
        isError: true,
      );
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _showSnackbar("Logged Out", "You’ve been logged out successfully.");
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackbar(
        "Email Sent",
        "Password reset link has been sent to $email",
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthExceptionsService.generateExceptionMessage(e);
      _showSnackbar("Error", errorMessage, isError: true);
      rethrow;
    } catch (e) {
      _showSnackbar(
        "Error",
        "Failed to send reset email. Please try again.",
        isError: true,
      );
      rethrow;
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        _showSnackbar(
          "Account Deleted",
          "Your account has been permanently deleted.",
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showSnackbar(
          "Re-authentication Required",
          "Please log out and log in again before deleting your account.",
          isError: true,
        );
      } else {
        final errorMessage = AuthExceptionsService.generateExceptionMessage(e);
        _showSnackbar("Error", errorMessage, isError: true);
      }
      rethrow;
    } catch (e) {
      _showSnackbar(
        "Error",
        "Failed to delete account. Please try again.",
        isError: true,
      );
      rethrow;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: isError
          ? const Color(0xFFD32F2F)
          : const Color(0xFF2E7D32),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
