import 'package:atm_simulator/app/atm/presentation/cubit/atm_cubit.dart';
import 'package:atm_simulator/app/setting/presentation/cubit/setting_cubit.dart';
import 'package:atm_simulator/core/observer/app_bloc_observer.dart';
import 'package:atm_simulator/core/presentation/theme/theme.dart';
import 'package:atm_simulator/core/router/router.dart';
import 'package:atm_simulator/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initServiceLocator();

  Bloc.observer = AppBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AtmCubit>()),
        BlocProvider(create: (context) => sl<SettingCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        builder: (context, child) {
          return child!;
        },
        child: BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'ATM Simulator',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state.theme == AppTheme.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}
