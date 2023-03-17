import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Type, AppException>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Type call(Params params);
}

class AtmParams extends Equatable {
  final String command;
  final Atm atm;

  const AtmParams({required this.command, required this.atm});

  @override
  List<Object> get props => [command, atm];
}
