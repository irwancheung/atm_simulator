import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/use_case/check_balance.dart';
import 'package:atm_simulator/app/atm/domain/use_case/clear_commands.dart';
import 'package:atm_simulator/app/atm/domain/use_case/deposit.dart';
import 'package:atm_simulator/app/atm/domain/use_case/log_in.dart';
import 'package:atm_simulator/app/atm/domain/use_case/log_out.dart';
import 'package:atm_simulator/app/atm/domain/use_case/show_help.dart';
import 'package:atm_simulator/app/atm/domain/use_case/transfer.dart';
import 'package:atm_simulator/app/atm/domain/use_case/withdraw.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'atm_state.dart';

class AtmCubit extends HydratedCubit<AtmState> {
  final LogIn logIn;
  final LogOut logOut;
  final CheckBalance checkBalance;
  final Deposit deposit;
  final Withdraw withdraw;
  final Transfer transfer;
  final ShowHelp showHelp;
  final ClearCommands clearCommands;
  AtmCubit({
    required this.logIn,
    required this.logOut,
    required this.checkBalance,
    required this.deposit,
    required this.withdraw,
    required this.transfer,
    required this.showHelp,
    required this.clearCommands,
  }) : super(
          const AtmState(
            atm: Atm(
              customers: [],
              history: [],
            ),
          ),
        );

  Future<void> executeCommand(String command) async {
    final commands = command.split(' ');
    final action = commands.first;

    switch (action) {
      case 'login':
        final either = await logIn(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      case 'logout':
        final either =
            await logOut(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      case 'balance':
        final either =
            await checkBalance(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      case 'deposit':
        final either =
            await deposit(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      case 'withdraw':
        final either =
            await withdraw(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      case 'transfer':
        final either =
            await transfer(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      case 'help':
        final either =
            await showHelp(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      case 'clear':
        final either =
            await clearCommands(AtmParams(command: command, atm: state.atm));
        _emitState(either, command);
        break;
      default:
        _emitUnknownCommandState(command);
    }
  }

  void _emitState(Either<Atm, AppException> either, String command) {
    either.fold(
      (atm) => emit(AtmState(atm: atm)),
      (e) => _emitAppExceptionState(command, e.message),
    );
  }

  void _emitAppExceptionState(String command, String errorMessage) {
    final updatedHistory = state.atm.history.toList();
    updatedHistory.addAll([
      '> $command',
      errorMessage,
    ]);

    emit(AtmState(atm: state.atm.copyWith(history: updatedHistory)));
  }

  void _emitUnknownCommandState(String command) {
    final updatedHistory = state.atm.history.toList();
    updatedHistory.addAll([
      '> $command',
      'Unknown command. Type "help" for a list of commands.',
    ]);

    emit(AtmState(atm: state.atm.copyWith(history: updatedHistory)));
  }

  @override
  AtmState? fromJson(Map<String, dynamic> json) {
    return AtmState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AtmState state) {
    return state.toMap();
  }
}
