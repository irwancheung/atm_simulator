import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'setting_state.dart';

class SettingCubit extends HydratedCubit<SettingState> {
  SettingCubit() : super(const SettingState(theme: AppTheme.light));

  void toLightMode() => emit(const SettingState(theme: AppTheme.light));

  void toDarkMode() => emit(const SettingState(theme: AppTheme.dark));

  @override
  SettingState? fromJson(Map<String, dynamic> json) {
    return SettingState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingState state) {
    return state.toMap();
  }
}
