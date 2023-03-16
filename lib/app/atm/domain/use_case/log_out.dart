import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

class LogOut implements UseCase<void, NoParams> {
  final AtmRepository repository;

  const LogOut({required this.repository});

  @override
  Future<Either<void, AppException>> call(NoParams params) {
    return repository.logOut();
  }
}
