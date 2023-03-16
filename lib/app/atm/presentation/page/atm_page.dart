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
              final setting = context.read<SettingCubit>();

              return IconButton(
                onPressed: () => state.theme == AppTheme.light
                    ? setting.toDarkMode()
                    : setting.toLightMode(),
                icon: Icon(
                  state.theme == AppTheme.light
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                iconSize: 30.r,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: text.body('AAA'),
            ),
          ),
          SizedBox(
            height: 95.h,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          prefix: text.body('\$ '),
                          border: const UnderlineInputBorder(),
                          enabledBorder: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
