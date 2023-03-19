import 'package:atm_simulator/app/atm/data/repository/atm_repository_impl.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/entity/creditor.dart';
import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
import 'package:atm_simulator/app/atm/domain/entity/debtor.dart';
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
  - activeCustomer.balance is same as passed atm.activeCustomer.balance argument,
  - customers is same as passed atm.customers argument,
  - history has 2 to 4 new history items,
  - if activeCustomer.creditor is not null, show creditor's username and amount in history,
  - if activeCustomer.debtor is not null, show debtor's username and amount in history,
  - followed by next history item contains word 'balance',
  - followed by next history item value is same as passed command,
  if checkBalance successfully done''', () async {
      // Arrange
      final tAtm = newAtm(
        activeCustomer: Customer(
          username: 'username',
          pin: pinEncrypter.encrypt('123456'),
          balance: 10000,
          debtor: const Debtor(username: 'username1', amount: 100),
          creditor: const Creditor(username: 'username2', amount: 100),
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
      expect(atm.history.length, tAtm.history.length + 4);
      expect(atm.history.last.toLowerCase(), contains('to'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('from'),
      );

      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains('balance'),
      );
      expect(
        atm.history[atm.history.length - 4].toLowerCase(),
        contains('balance'),
      );
    });
  });
}
