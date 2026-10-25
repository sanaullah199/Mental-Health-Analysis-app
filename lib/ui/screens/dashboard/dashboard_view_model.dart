import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/core/models/user_model.dart';
import 'package:mental_health_analysis_app/core/services/auth_services.dart';
import 'package:mental_health_analysis_app/core/services/database_services.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';

class DashboardViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseServices _databaseServices = locator<DatabaseServices>();

  UserModel? _currentUser;
  AssessmentModel? _latestAssessment;

  UserModel? get currentUser => _currentUser;
  AssessmentModel? get latestAssessment => _latestAssessment;

  Future<void> initialize() async {
    setState(ViewState.busy);
    await loadUserData();
    await loadLatestAssessment();
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

  String get userName => _currentUser?.name ?? "User";
  String get userEmail => _currentUser?.email ?? "";
  int get healthScore => _latestAssessment?.aiScore ?? 75;
  int get stressLevel => _latestAssessment?.stressLevelNumber ?? 3;
  String get currentMood => _latestAssessment?.mood ?? "Okay";
}
