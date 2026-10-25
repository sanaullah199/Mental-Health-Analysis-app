
import 'package:get_it/get_it.dart';
import 'package:mental_health_analysis_app/core/services/auth_services.dart';
import 'package:mental_health_analysis_app/core/services/database_services.dart';

final locator = GetIt.instance;

setupLocator() {
  // locator.registerSingleton<LocalStorageServices>(LocalStorageServices());
  // locator.registerSingleton<ApiService>(ApiService());
  locator.registerSingleton(AuthService());
   locator.registerSingleton(DatabaseServices());
  // locator.registerSingleton(NotificationService());
}