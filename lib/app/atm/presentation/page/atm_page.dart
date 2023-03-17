import 'package:atm_simulator/app/atm/presentation/cubit/atm_cubit.dart';
import 'package:atm_simulator/app/atm/presentation/widget/command_input_field.dart';
import 'package:atm_simulator/app/atm/presentation/widget/theme_mode_toggle.dart';
import 'package:atm_simulator/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AtmPage extends StatefulWidget {
  const AtmPage({super.key});

  @override
  State<AtmPage> createState() => _AtmPageState();
}

class _AtmPageState extends State<AtmPage> {
  final _inputController = TextEditingController();
  final _inputfocus = FocusNode();

  void _onCommandSubmit(String command) {
    _inputController.clear();
    _inputfocus.requestFocus();

    context.read<AtmCubit>().executeCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [ThemeModeToggle()],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<AtmCubit, AtmState>(
                builder: (context, state) {
                  final atm = state.atm;
                  final history = atm.history.toList();

                  return ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Text(history[index])),
                            ],
                          ),
                          SizedBox(height: 5.h),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            CommandInputField(
              controller: _inputController,
              focusNode: _inputfocus,
              onSubmitted: _onCommandSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
