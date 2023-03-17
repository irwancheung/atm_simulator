import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

class CheckBalance implements UseCase<Atm, AtmParams> {
  final AtmRepository repository;

  const CheckBalance({required this.repository});

  @override
  Future<Either<Atm, AppException>> call(AtmParams params) {
    return repository.checkBalance(command: params.command, atm: params.atm);
  }
}
