import 'package:atm_simulator/app/atm/data/model/atm_model.dart';
import 'package:atm_simulator/app/atm/data/model/customer_model.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/util/pin_encrypter.dart';
import 'package:atm_simulator/export.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

class AtmRepositoryImpl implements AtmRepository {
  final PinEncrypter pinEncrypter;

  const AtmRepositoryImpl({required this.pinEncrypter});

  @override
  Future<Either<Atm, AppException>> logIn({
    required String command,
    required Atm atm,
  }) async {
    final commands = command.split(' ');

    if (commands.length != 3) {
      return right(const AppException(invalidParams));
    }

    final username = commands[1].toLowerCase();
    final pin = commands[2];

    if (username.contains(RegExp(r'[^\w\s]'))) {
      return right(const AppException(invalidUsername));
    }

    if (int.tryParse(pin) == null) {
      return right(const AppException(pinMustNumeric));
    }

    if (pin.length != 6) {
      return right(const AppException(pinMustSixDigits));
    }

    if (atm.activeCustomer != null) {
      return right(const AppException(alreadyLoggedIn));
    }

    final customer = atm.customers.firstWhereOrNull(
      (customer) => customer.username == username,
    );

    if (customer != null) {
      final matchedPin = pinEncrypter.comparePin(pin, customer.pin);

      if (!matchedPin) {
        return right(const AppException(pinNotMatch));
      }

      final newAtm = (atm as AtmModel).copyWith(
        activeCustomer: customer as CustomerModel,
        updatedAt: DateTime.now(),
      );

      return left(newAtm);
    }

    final newCustomer = CustomerModel(
      username: username,
      pin: pinEncrypter.encrypt(pin),
      balance: 0,
    );

    final newAtm = (atm as AtmModel).copyWith(
      customers: [
        ...atm.customers.map((customer) => customer as CustomerModel),
        newCustomer
      ],
      activeCustomer: newCustomer,
      updatedAt: DateTime.now(),
    );

    return left(newAtm);
  }

  @override
  Future<Either<Atm, AppException>> logOut({required Atm atm}) async {
    if (atm.activeCustomer == null) {
      return right(const AppException(alreadyLoggedOut));
    }

    final atmModel = atm as AtmModel;

    final newAtm = AtmModel(
      customers: atmModel.customers,
      history: atmModel.history,
      updatedAt: DateTime.now(),
    );

    return left(newAtm);
  }

  @override
  Future<Either<Atm, AppException>> checkBalance({
    required String command,
    required Atm atm,
  }) {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Atm, AppException>> deposit({
    required String command,
    required Atm atm,
  }) {
    // TODO: implement deposit
    throw UnimplementedError();
  }

  @override
  Future<Either<Atm, AppException>> withdraw({
    required String command,
    required Atm atm,
  }) {
    // TODO: implement withdraw
    throw UnimplementedError();
  }

  @override
  Future<Either<Atm, AppException>> transfer({
    required String command,
    required Atm atm,
  }) {
    // TODO: implement transfer
    throw UnimplementedError();
  }

  @override
  Future<Either<Atm, AppException>> showHelp({
    required String command,
    required Atm atm,
  }) async {
    try {
      final atmModel = atm as AtmModel;
      final history = atmModel.history.toList();

      history.addAll([
        _joinCommandsAndAddPrefix([command]),
        '''
Available commands :
- login <username> <pin> : Log in user
- logout : Log out user
- deposit <amount> : Deposit this amount to your saving
- withdraw <amount> : Withdraw this amount from your saving
- transfer <recipient> <amount> : Transfer this amount to another customer
- clear : Clear the screen
- help : Show this help message
'''
      ]);

      return left(
        atmModel.copyWith(history: history, updatedAt: DateTime.now()),
      );
    } catch (e, s) {
      logger.e(e, s);
      return right(AppException(e.toString()));
    }
  }

  @override
  Future<Either<Atm, AppException>> clearCommands({
    required String command,
    required Atm atm,
  }) async {
    try {
      final atmModel = atm as AtmModel;
      final history = atm.activeCustomer != null
          ? const <String>[]
          : <String>[
              'Welcome to ATM Simulator',
              'Please type : `login <username> <pin>` to log in or register new account.',
            ];

      return left(
        atmModel.copyWith(history: history, updatedAt: DateTime.now()),
      );
    } catch (e, s) {
      logger.e(e, s);
      return right(AppException(e.toString()));
    }
  }

  String _joinCommandsAndAddPrefix(List<String> commands) {
    return '> ${commands.join(' ')}';
  }
}
