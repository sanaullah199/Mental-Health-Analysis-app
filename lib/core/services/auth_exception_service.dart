// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionsService {
  static String generateExceptionMessage(FirebaseAuthException e) {
    print('Firebase Auth Error Code: ${e.code}');

    String errorMessage;
    switch (e.code) {
      // Email/Password Sign Up Errors
      case "email-already-in-use":
        errorMessage =
            "This email is already registered. Please login or reset your password.";
        break;
      case "invalid-email":
        errorMessage =
            "The email address is not valid. Please check and try again.";
        break;
      case "weak-password":
        errorMessage =
            "Password is too weak. Use at least 6 characters with letters and numbers.";
        break;
      case "operation-not-allowed":
        errorMessage =
            "Email/Password sign-in is not enabled. Please contact support.";
        break;

      // Email/Password Sign In Errors
      case "wrong-password":
        errorMessage =
            "Incorrect password. Please try again or reset your password.";
        break;
      case "user-not-found":
        errorMessage =
            "No account found with this email. Please sign up first.";
        break;
      case "user-disabled":
        errorMessage =
            "This account has been disabled. Please contact support.";
        break;
      case "invalid-credential":
        errorMessage =
            "The credentials provided are invalid. Please try again.";
        break;

      // Account Management Errors
      case "requires-recent-login":
        errorMessage =
            "This operation requires recent authentication. Please login again.";
        break;
      case "account-exists-with-different-credential":
        errorMessage =
            "An account already exists with the same email but different sign-in method.";
        break;
      case "credential-already-in-use":
        errorMessage =
            "This credential is already associated with a different account.";
        break;

      // Network & Connection Errors
      case "network-request-failed":
        errorMessage =
            "Network error. Please check your internet connection and try again.";
        break;
      case "too-many-requests":
        errorMessage = "Too many attempts. Please wait a moment and try again.";
        break;
      case "timeout":
        errorMessage =
            "Request timed out. Please check your connection and try again.";
        break;

      // Token & Session Errors
      case "invalid-verification-code":
        errorMessage = "The verification code is invalid. Please try again.";
        break;
      case "invalid-verification-id":
        errorMessage =
            "The verification ID is invalid. Please request a new code.";
        break;
      case "session-expired":
        errorMessage = "Your session has expired. Please login again.";
        break;
      case "user-token-expired":
        errorMessage = "Your session has expired. Please login again.";
        break;
      case "invalid-user-token":
        errorMessage =
            "Your credentials are no longer valid. Please login again.";
        break;

      // Phone Authentication Errors
      case "invalid-phone-number":
        errorMessage =
            "The phone number format is invalid. Please check and try again.";
        break;
      case "missing-phone-number":
        errorMessage = "Please provide a phone number.";
        break;
      case "quota-exceeded":
        errorMessage = "SMS quota exceeded. Please try again later.";
        break;
      case "captcha-check-failed":
        errorMessage = "reCAPTCHA verification failed. Please try again.";
        break;

      // Provider Errors (Google, Facebook, etc.)
      case "popup-blocked":
        errorMessage =
            "Sign-in popup was blocked. Please allow popups and try again.";
        break;
      case "popup-closed-by-user":
        errorMessage = "Sign-in was cancelled. Please try again.";
        break;
      case "unauthorized-domain":
        errorMessage = "This domain is not authorized for OAuth operations.";
        break;
      case "provider-already-linked":
        errorMessage = "This account is already linked to another provider.";
        break;

      // Password Reset Errors
      case "expired-action-code":
        errorMessage =
            "This link has expired. Please request a new password reset.";
        break;
      case "invalid-action-code":
        errorMessage = "This link is invalid or has already been used.";
        break;
      case "missing-email":
        errorMessage = "Please provide an email address.";
        break;

      // Multi-Factor Authentication Errors
      case "multi-factor-auth-required":
        errorMessage =
            "Please complete multi-factor authentication to continue.";
        break;
      case "maximum-second-factor-count-exceeded":
        errorMessage = "Maximum number of second factors exceeded.";
        break;
      case "second-factor-already-enrolled":
        errorMessage = "This second factor is already enrolled.";
        break;

      // App & Configuration Errors
      case "app-not-authorized":
        errorMessage =
            "This app is not authorized to use Firebase Authentication.";
        break;
      case "invalid-api-key":
        errorMessage = "Invalid API key. Please contact support.";
        break;
      case "web-storage-unsupported":
        errorMessage = "Web storage is not supported or disabled.";
        break;

      // Custom Token Errors
      case "invalid-custom-token":
        errorMessage = "The custom token format is incorrect.";
        break;
      case "custom-token-mismatch":
        errorMessage =
            "The custom token corresponds to a different Firebase project.";
        break;

      // Email Verification Errors
      case "unverified-email":
        errorMessage = "Please verify your email address before continuing.";
        break;

      // General Errors
      case "internal-error":
        errorMessage = "An internal error occurred. Please try again later.";
        break;
      case "missing-client-identifier":
        errorMessage = "Missing client identifier. Please contact support.";
        break;
      case "app-deleted":
        errorMessage = "This Firebase app instance has been deleted.";
        break;

      default:
        errorMessage =
            "An unexpected error occurred: ${e.message ?? 'Please try again.'}";
    }

    return errorMessage;
  }
}
