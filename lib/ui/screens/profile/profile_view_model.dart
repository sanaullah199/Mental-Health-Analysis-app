import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/core/models/user_model.dart';
import 'package:mental_health_analysis_app/core/services/auth_services.dart';
import 'package:mental_health_analysis_app/core/services/database_services.dart';
import 'package:mental_health_analysis_app/core/services/local_storage_services.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/ui/screens/auth/sign_in/sign_in_screen.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseServices _databaseServices = locator<DatabaseServices>();

  UserModel? _currentUser;
  AssessmentModel? _latestAssessment;
  int _totalConversations = 0;

  UserModel? get currentUser => _currentUser;
  AssessmentModel? get latestAssessment => _latestAssessment;
  int get totalConversations => _totalConversations;

  String get userName => _currentUser?.name ?? "User";
  String get userEmail => _currentUser?.email ?? "";
  String get profileImage => _currentUser?.profileImage ?? "";
  int get healthScore => _latestAssessment?.aiScore ?? 0;
  String get currentMood => _latestAssessment?.mood ?? "Neutral";
  String get sleepQuality => _latestAssessment?.sleepQuality ?? "N/A";
  String get stressLevel => _latestAssessment?.stressLevel ?? "N/A";

  Future<void> initialize() async {
    setState(ViewState.busy);
    await loadUserData();
    await loadLatestAssessment();
    await loadConversationCount();
    setState(ViewState.idle);
  }

  Future<void> loadUserData() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _currentUser = await _databaseServices.getUser(userId);
      notifyListeners();
    }
  }

  Future<void> loadLatestAssessment() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _latestAssessment = await _databaseServices.getAssessment(userId);
      notifyListeners();
    }
  }

  Future<void> loadConversationCount() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      final conversations = await _databaseServices
          .getUserConversations(userId)
          .first;
      _totalConversations = conversations.docs.length;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String name,
    String? profileImage,
  }) async {
    setState(ViewState.busy);
    try {
      await _databaseServices.updateNameAndImage(
        name: name,
        profileImage: profileImage ?? _currentUser?.profileImage ?? "",
      );
      await loadUserData();
      setState(ViewState.idle);
    } catch (e) {
      debugPrint("Error updating profile: $e");
      setState(ViewState.idle);
    }
  }

  Future<void> logout() async {
    LocalStorageServices().loginAlready = false;
    Get.offAll(SignInScreen());
    await _authService.logout();
  }

  Future<void> changePassword() async {
    try {
      final email = _currentUser?.email;
      if (email != null) {
        await _authService.resetPassword(email);
      }
    } catch (e) {
      debugPrint("❌ Error changing password: $e");
    }
  }

  Future<void> deleteAccount() async {
    // LocalStorageServices().assessmentCompleted = false;
    // LocalStorageServices().welcomeCompleted = false;
    // LocalStorageServices().assessmentCompleted = false;
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      // Delete user data from Firestore
      LocalStorageServices().assessmentCompleted = false;
      LocalStorageServices().welcomeCompleted = false;
      LocalStorageServices().loginAlready = false;

      await _databaseServices.deleteUserData(userId);

      // Delete Firebase Auth account
      await _authService.deleteAccount();

      debugPrint("✅ Account deleted successfully");
    } catch (e) {
      debugPrint("❌ Error deleting account: $e");
      rethrow;
    }
  }

  String getJoinedDate() {
    if (_latestAssessment != null) {
      final date = _latestAssessment!.createdAt.toDate();
      return "${date.day}/${date.month}/${date.year}";
    }
    return "N/A";
  }

  List<String> get concerns => _latestAssessment?.concerns ?? [];
  List<String> get recommendations => _latestAssessment?.recommendations ?? [];
}
