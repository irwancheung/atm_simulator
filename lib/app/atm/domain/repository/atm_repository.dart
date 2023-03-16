import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:dartz/dartz.dart';

abstract class AtmRepository {
  Future<Either<void, AppException>> logIn({required String userId});
  Future<Either<void, AppException>> logOut();
  Future<Either<void, AppException>> deposit({required int amount});
  Future<Either<void, AppException>> withdraw({required int amount});
  Future<Either<void, AppException>> transfer({
    required String recipientId,
    required int amount,
  });
}
