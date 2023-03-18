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
  final _scrollController = ScrollController();
  final _inputfocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _onCommandSubmitted(String command) {
    _inputController.clear();
    _inputfocus.requestFocus();
    _scrollToBottom();

    context.read<AtmCubit>().executeCommand(command.toLowerCase().trim());
  }

  void _scrollToBottom() =>
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [ThemeModeToggle()],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<AtmCubit, AtmState>(
                listener: (context, state) {
                  final atm = state.atm;

                  if (atm.activeCustomer == null && atm.history.isEmpty) {
                    context.read<AtmCubit>().executeCommand('clear');
                  }
                },
                builder: (context, state) {
                  final atm = state.atm;
                  final history = atm.history.toList();

                  if (atm.activeCustomer == null && history.isEmpty) {
                    context.read<AtmCubit>().executeCommand('clear');
                  }

                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: Scrollbar(
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: history.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              if (index == 0) SizedBox(height: 5.h),
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
                      ),
                    ),
                  );
                },
              ),
            ),
            CommandInputField(
              controller: _inputController,
              focusNode: _inputfocus,
              onSubmitted: _onCommandSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
