import 'package:atm_simulator/app/setting/presentation/cubit/setting_cubit.dart';
import 'package:atm_simulator/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        final setting = context.read<SettingCubit>();

        return IconButton(
          onPressed: () => state.theme == AppTheme.light
              ? setting.toDarkMode()
              : setting.toLightMode(),
          icon: Icon(
            state.theme == AppTheme.light ? Icons.light_mode : Icons.dark_mode,
          ),
          iconSize: 30.r,
        );
      },
    );
  }
}
