import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:dartz/dartz.dart';

abstract class AtmRepository {
  Future<Either<Atm, AppException>> logIn({
    required String command,
    required Atm atm,
  });

  Future<Either<Atm, AppException>> logOut({required Atm atm});

  Future<Either<Atm, AppException>> checkBalance({
    required String command,
    required Atm atm,
  });

  Future<Either<Atm, AppException>> deposit({
    required String command,
    required Atm atm,
  });

  Future<Either<Atm, AppException>> withdraw({
    required String command,
    required Atm atm,
  });

  Future<Either<Atm, AppException>> transfer({
    required String command,
    required Atm atm,
  });

  Future<Either<Atm, AppException>> showHelp({
    required String command,
    required Atm atm,
  });

  Future<Either<Atm, AppException>> clearCommands({
    required String command,
    required Atm atm,
  });
}
