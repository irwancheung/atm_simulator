import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/use_case/check_balance.dart';
import 'package:atm_simulator/app/atm/domain/use_case/clear_commands.dart';
import 'package:atm_simulator/app/atm/domain/use_case/deposit.dart';
import 'package:atm_simulator/app/atm/domain/use_case/log_in.dart';
import 'package:atm_simulator/app/atm/domain/use_case/log_out.dart';
import 'package:atm_simulator/app/atm/domain/use_case/show_help.dart';
import 'package:atm_simulator/app/atm/domain/use_case/transfer.dart';
import 'package:atm_simulator/app/atm/domain/use_case/withdraw.dart';
import 'package:atm_simulator/app/atm/presentation/cubit/atm_cubit.dart';
import 'package:atm_simulator/core/const/exception_const.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/hydrated_bloc.dart';
import 'atm_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LogIn>(),
  MockSpec<LogOut>(),
  MockSpec<CheckBalance>(),
  MockSpec<Deposit>(),
  MockSpec<Withdraw>(),
  MockSpec<Transfer>(),
  MockSpec<ShowHelp>(),
  MockSpec<ClearCommands>(),
])
void main() {
  initHydratedStorage();

  late AtmCubit cubit;
  late MockLogIn mockLogIn;
  late MockLogOut mockLogOut;
  late MockCheckBalance mockCheckBalance;
  late MockDeposit mockDeposit;
  late MockWithdraw mockWithdraw;
  late MockTransfer mockTransfer;
  late MockShowHelp mockShowHelp;
  late MockClearCommands mockClearCommands;

  setUp(() {
    mockLogIn = MockLogIn();
    mockLogOut = MockLogOut();
    mockCheckBalance = MockCheckBalance();
    mockDeposit = MockDeposit();
    mockWithdraw = MockWithdraw();
    mockTransfer = MockTransfer();
    mockShowHelp = MockShowHelp();
    mockClearCommands = MockClearCommands();

    cubit = AtmCubit(
      logIn: mockLogIn,
      logOut: mockLogOut,
      checkBalance: mockCheckBalance,
      deposit: mockDeposit,
      withdraw: mockWithdraw,
      transfer: mockTransfer,
      showHelp: mockShowHelp,
      clearCommands: mockClearCommands,
    );
  });

  const tAtm = Atm(customers: [], history: []);

  test('Initial value of [AtmState.atm] value is correct', () async {
    expect(cubit.state.atm, equals(tAtm));
  });

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('login') is called.",
    setUp: () {
      when(mockLogIn(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('login'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('logout') is called.",
    setUp: () {
      when(mockLogOut(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('logout'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('balance') is called.",
    setUp: () {
      when(mockCheckBalance(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('balance'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('deposit') is called.",
    setUp: () {
      when(mockDeposit(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('deposit'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('withdraw') is called.",
    setUp: () {
      when(mockWithdraw(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('withdraw'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('transfer') is called.",
    setUp: () {
      when(mockTransfer(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('transfer'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('help') is called.",
    setUp: () {
      when(mockShowHelp(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('help'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] when cubit.executeCommand('clear') is called.",
    setUp: () {
      when(mockClearCommands(any)).thenAnswer((_) async => const Left(tAtm));
    },
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('clear'),
    expect: () => const <AtmState>[AtmState(atm: tAtm)],
  );

  blocTest<AtmCubit, AtmState>(
    "emits [AtmState] with last item of history contains 'unknown command' when cubit.executeCommand() with passed unknown command is called.",
    build: () => cubit,
    act: (bloc) => cubit.executeCommand('unknown'),
    expect: () => const <AtmState>[
      AtmState(atm: Atm(customers: [], history: ['> unknown', unknownCommand]))
    ],
    verify: (cubit) =>
        expect(cubit.state.atm.history.last, equals(unknownCommand)),
  );
}
