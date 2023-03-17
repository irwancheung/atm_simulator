import 'package:atm_simulator/app/atm/cubit/atm_cubit.dart';
import 'package:atm_simulator/app/atm/data/repository/atm_repository_impl.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/app/atm/domain/use_case/clear_commands.dart';
import 'package:atm_simulator/app/atm/domain/use_case/deposit.dart';
import 'package:atm_simulator/app/atm/domain/use_case/log_in.dart';
import 'package:atm_simulator/app/atm/domain/use_case/log_out.dart';
import 'package:atm_simulator/app/atm/domain/use_case/show_help.dart';
import 'package:atm_simulator/app/atm/domain/use_case/transfer.dart';
import 'package:atm_simulator/app/atm/domain/use_case/withdraw.dart';
import 'package:atm_simulator/app/setting/cubit/setting_cubit.dart';
import 'package:atm_simulator/core/presentation/widget/app_text.dart';
import 'package:atm_simulator/core/util/logger.dart';
import 'package:atm_simulator/core/util/pin_encrypter.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
final text = sl<AppText>();
final logger = sl<Logger>();

Future<void> initServiceLocator() async {
  //! Bloc
  sl.registerFactory(
    () => AtmCubit(
      logIn: sl(),
      logOut: sl(),
      deposit: sl(),
      withdraw: sl(),
      transfer: sl(),
      showHelp: sl(),
      clearCommands: sl(),
    ),
  );

  sl.registerFactory(() => SettingCubit());

  //! Repository
  sl.registerLazySingleton<AtmRepository>(() => AtmRepositoryImpl());

  //! UseCase
  sl.registerLazySingleton(() => LogIn(repository: sl()));
  sl.registerLazySingleton(() => LogOut(repository: sl()));
  sl.registerLazySingleton(() => Deposit(repository: sl()));
  sl.registerLazySingleton(() => Withdraw(repository: sl()));
  sl.registerLazySingleton(() => Transfer(repository: sl()));
  sl.registerLazySingleton(() => ShowHelp(repository: sl()));
  sl.registerLazySingleton(() => ClearCommands(repository: sl()));

  //! Core
  sl.registerLazySingleton(() => AppText());
  sl.registerLazySingleton(() => Logger());
  sl.registerLazySingleton(() => PinEncrypter());
}
