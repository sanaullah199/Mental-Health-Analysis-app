import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/core/models/assessment_model.dart';
import 'package:mental_health_analysis_app/core/services/database_services.dart';
import 'package:mental_health_analysis_app/core/services/local_storage_services.dart';
import 'package:mental_health_analysis_app/core/view_models/base_view_model.dart';
import 'package:mental_health_analysis_app/locator.dart';
import 'package:mental_health_analysis_app/ui/screens/all_set/allset_screen.dart';

class CompilingAssessmentViewModel extends BaseViewModel {
  final DatabaseServices _databaseServices = locator<DatabaseServices>();
  final LocalStorageServices _localStorageServices = LocalStorageServices();
  AssessmentModel assessmentModel;

  CompilingAssessmentViewModel(this.assessmentModel);

  Future<void> setup() async {
    saveAssessment();
    initState();
  }

  Future<void> saveAssessment() async {
    setState(ViewState.busy);
    await _databaseServices.saveAssessment(assessmentModel);
    _localStorageServices.assessmentCompleted = true;

    setState(ViewState.idle);
  }

  void initState() {
    Future.delayed(const Duration(seconds: 10), () {
      Get.off(AllsetScreen(assessmentModel: assessmentModel,));
    });
    notifyListeners();
  }
}
