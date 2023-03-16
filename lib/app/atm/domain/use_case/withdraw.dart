import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Withdraw implements UseCase<void, WithdrawParams> {
  final AtmRepository repository;

  const Withdraw({required this.repository});

  @override
  Future<Either<void, AppException>> call(WithdrawParams params) {
    return repository.withdraw(amount: params.amount);
  }
}

class WithdrawParams extends Equatable {
  final int amount;

  const WithdrawParams({required this.amount});

  @override
  List<Object> get props => [amount];
}
