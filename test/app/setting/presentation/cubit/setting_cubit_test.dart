import 'package:atm_simulator/app/setting/presentation/cubit/setting_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helper/hydrated_bloc.dart';

void main() {
  initHydratedStorage();

  late SettingCubit cubit;

  setUp(() => cubit = SettingCubit());

  group('Theme Mode', () {
    test('Initial theme state should be AppTheme.light', () async {
      // Assert
      expect(cubit.state.theme, AppTheme.light);
    });

    test('toDarkMode should emit AppTheme.dark', () async {
      // Act
      cubit.toDarkMode();

      // Assert
      expect(cubit.state.theme, AppTheme.dark);
    });

    test('toLightMode should emit AppTheme.light', () async {
      // Act
      cubit.toLightMode();

      // Assert
      expect(cubit.state.theme, AppTheme.light);
    });
  });
}
