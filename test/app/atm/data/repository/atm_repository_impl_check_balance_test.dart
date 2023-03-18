import 'package:atm_simulator/app/atm/data/repository/atm_repository_impl.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
import 'package:atm_simulator/core/const/exception_const.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/util/pin_encrypter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtmRepositoryImpl repository;
  late PinEncrypter pinEncrypter;

  setUp(() {
    pinEncrypter = PinEncrypter();
    repository = AtmRepositoryImpl(pinEncrypter: pinEncrypter);
  });

  group('checkBalance', () {
    Atm newAtm({
      Customer? activeCustomer,
      List<Customer> customers = const [],
      List<String> history = const [],
    }) {
      return Atm(
        activeCustomer: activeCustomer,
        customers: customers,
        history: history,
      );
    }

    test(
        'should return Right(AppException) with specific message if atm.activeCustomer is null',
        () async {
      // Arrange
      final tAtm = newAtm();
      const tMessage = balanceNotLoggedIn;

      // Act
      final result = await repository.checkBalance(atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
should return Left(Atm) where
  - atm.activeCustomer.balance is same as passed atm.activeCustomer.balance argument,
  - atm.customers is same as passed atm.customers argument,
  - atm.history has 2 new history items containing word 'balance',
  if checkBalance successfully done''', () async {
      // Arrange
      final tAtm = newAtm(
        activeCustomer: Customer(
          username: 'username',
          pin: pinEncrypter.encrypt('123456'),
          balance: 10000,
        ),
      );

      // Act
      final result = await repository.checkBalance(atm: tAtm);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer!.balance, tAtm.activeCustomer!.balance);
      expect(atm.customers, tAtm.customers);
      expect(atm.history.length, tAtm.history.length + 2);
      expect(atm.history.last.toLowerCase(), contains('balance'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('balance'),
      );
    });
  });
}
