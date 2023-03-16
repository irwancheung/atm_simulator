import 'package:atm_simulator/app/setting/cubit/setting_cubit.dart';
import 'package:atm_simulator/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AtmPage extends StatelessWidget {
  const AtmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<SettingCubit, SettingState>(
            builder: (context, state) {
              late final void Function() onPressed;
              late final IconData icon;

              if (state.theme == AppTheme.light) {
                icon = Icons.light_mode;
                onPressed = () => context.read<SettingCubit>().toDarkMode();
              } else {
                icon = Icons.dark_mode;
                onPressed = () => context.read<SettingCubit>().toLightMode();
              }

              return IconButton(
                onPressed: onPressed,
                icon: Icon(icon),
                iconSize: 30.r,
              );
            },
          ),
        ],
      ),
      body: SafeArea(child: Container()),
    );
  }
}
