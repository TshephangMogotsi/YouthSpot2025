import 'package:get_it/get_it.dart';
import '../config/theme_manager.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<ThemeManager>(() => ThemeManager());
}
