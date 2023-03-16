import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Deposit implements UseCase<void, DepositParams> {
  final AtmRepository repository;

  const Deposit({required this.repository});

  @override
  Future<Either<void, AppException>> call(DepositParams params) {
    return repository.deposit(amount: params.amount);
  }
}

class DepositParams extends Equatable {
  final int amount;

  const DepositParams({required this.amount});

  @override
  List<Object> get props => [amount];
}
