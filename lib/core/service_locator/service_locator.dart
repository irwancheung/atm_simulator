import 'package:atm_simulator/app/setting/cubit/setting_cubit.dart';
import 'package:atm_simulator/core/presentation/widget/app_text.dart';
import 'package:atm_simulator/core/util/logger.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
final text = sl<AppText>();
final logger = sl<Logger>();

Future<void> initServiceLocator() async {
  //! Setting
  sl.registerFactory(() => SettingCubit());

  //! Core
  sl.registerLazySingleton(() => AppText());
  sl.registerLazySingleton(() => Logger());
}
