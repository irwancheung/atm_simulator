import 'package:atm_simulator/app/atm/data/model/atm_model.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/service_locator/service_locator.dart';
import 'package:dartz/dartz.dart';

class AtmRepositoryImpl implements AtmRepository {
  @override
  Future<Either<Atm, AppException>> logIn({
    required String command,
    required Atm atm,
  }) async {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Atm, AppException>> logOut({
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
