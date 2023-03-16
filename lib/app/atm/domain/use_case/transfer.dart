import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Transfer implements UseCase<void, TransferParams> {
  final AtmRepository repository;

  const Transfer({required this.repository});

  @override
  Future<Either<void, AppException>> call(TransferParams params) {
    return repository.transfer(
      recipientId: params.recipientId,
      amount: params.amount,
    );
  }
}

class TransferParams extends Equatable {
  final String recipientId;
  final int amount;

  const TransferParams({required this.recipientId, required this.amount});

  @override
  List<Object> get props => [amount];
}
