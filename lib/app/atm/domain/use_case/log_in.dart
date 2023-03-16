import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LogIn implements UseCase<void, LoginParams> {
  final AtmRepository repository;

  const LogIn({required this.repository});

  @override
  Future<Either<void, AppException>> call(LoginParams params) {
    return repository.logIn(userId: params.userId);
  }
}

class LoginParams extends Equatable {
  final String userId;

  const LoginParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
