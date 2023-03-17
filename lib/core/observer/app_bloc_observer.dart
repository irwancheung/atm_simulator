import 'package:atm_simulator/core/service_locator/service_locator.dart';
import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver();

  // @override
  // void onCreate(BlocBase bloc) {
  //   logger.bloc('onCreate: $bloc');
  //   super.onCreate(bloc);
  // }

  // @override
  // void onEvent(Bloc bloc, Object? event) {
  //   super.onEvent(bloc, event);
  //   logger.bloc('onEvent: $bloc\n$event');
  // }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('onError: $bloc\n$error\n$stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  // @override
  // void onChange(BlocBase bloc, Change change) {
  //   super.onChange(bloc, change);
  //   logger.bloc('onChange: $bloc\n$change');
  // }

  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   super.onTransition(bloc, transition);
  //   logger.bloc('onTransition: $bloc\n$transition');
  // }
}
