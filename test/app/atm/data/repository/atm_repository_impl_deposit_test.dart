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

  group('deposit', () {
    const tUsername = 'irwan';
    const tPin = '123456';

    const tValidCommand = 'deposit 100000';

    const tCustomer = Customer(
      username: tUsername,
      pin: tPin,
      balance: 1000000,
    );

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

    Atm newAtmWithActiveCustomer() {
      return newAtm(
        activeCustomer: tCustomer,
        customers: [tCustomer],
      );
    }

    test(
        'should return Right(AppException) with specific message if customer is not logged in yet',
        () async {
      // Arrange
      const tCommand = tValidCommand;
      const tMessage = depositNotLoggedIn;
      final tAtm = newAtm();

      // Act
      final result = await repository.deposit(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if command argument is not consists of 2 words',
        () async {
      // Arrange
      const tCommand = 'deposit';
      const tMessage = depositInvalidParams;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.deposit(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is not a number',
        () async {
      // Arrange
      const tCommand = 'deposit 20a00';
      const tMessage = depositInvalidAmount;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.deposit(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is zero or negative',
        () async {
      // Arrange
      const tCommand = 'deposit -100000';
      const tMessage = depositInvalidAmount;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.deposit(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
should return Left(Atm) where
  - activeCustomer is not null,
  - activeCustomer.balance is increased by amount,
  - customers is updated with new activeCustomer,
  - history has 2 new history items,
  - last history item contains word 'balance now',
  - second last history item contains word from command argument,
  if deposit successfully done''', () async {
      // Arrange
      const tCommand = tValidCommand;
      const tAmount = 100000;
      final tAtm = newAtmWithActiveCustomer();
      final tActiveCustomerNewBalance = tCustomer.balance + tAmount;

      // Act
      final result = await repository.deposit(command: tCommand, atm: tAtm);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(atm.activeCustomer!.balance, tActiveCustomerNewBalance);
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tCustomer.username,
        ),
        equals(atm.activeCustomer),
      );
      expect(atm.history.length, tAtm.history.length + 2);
      expect(atm.history.last, contains('balance now'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains(tCommand),
      );
    });

    test('''
while activeCustomer.creditor is not null should return Left(Atm) where
  - activeCustomer is not null,
  - deposit amount is used to deduct activeCustomer.creditor.balance first,
  - then same amount is used to deduct targetCustomer.debtor.balance and increase targetCustomer.balance,
  - if activeCustomer.creditor.balance is zero, activeCustomer.creditor is set to null,
  - if targetCustomer.debtor.balance is zero, targetCustomer.debtor is set to null,
  - if there is remainder, activeCustomer.balance is increased by remainder,
  - customers is updated with new activeCustomer and targetCustomer,
  - history is update with new items same as above,
  - if transfer occured, then history has 3 new history items, which is
    - last history item contains word 'balance now',
    - second last history item contains word 'transfer',
    - third last history item contains word from command argument,
  - if activeCustomer.creditor is not null then show creditor's information in last history item,
  if deposit successfully done''', () async {
      // Arrange
      const tCommand = 'deposit 150000';
      const tAmount = 150000;

      final tActiveCustomerPreAct = tCustomer.copyWith(
        balance: 0,
        creditor: const Creditor(
          username: 'cindy',
          amount: 100000,
        ),
      );

      const tTargetCustomerPreAct = Customer(
        username: 'cindy',
        pin: '123456',
        balance: 100000,
        debtor: Debtor(
          username: tUsername,
          amount: 100000,
        ),
      );

      final tAtm = newAtm(
        activeCustomer: tActiveCustomerPreAct,
        customers: [tActiveCustomerPreAct, tTargetCustomerPreAct],
      );

      final tDepositRemainder =
          tAmount - tActiveCustomerPreAct.creditor!.amount;
      final tTotalTransfer = tAmount - tDepositRemainder;

      final tActiveCustomerPostAct = Customer(
        username: tActiveCustomerPreAct.username,
        pin: tActiveCustomerPreAct.pin,
        balance: tActiveCustomerPreAct.balance + tDepositRemainder,
      );

      final tTargetCustomerPostAct = Customer(
        username: tTargetCustomerPreAct.username,
        pin: tTargetCustomerPreAct.pin,
        balance: tTargetCustomerPreAct.balance + tTotalTransfer,
      );

      // Act
      final result = await repository.deposit(command: tCommand, atm: tAtm);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(atm.activeCustomer, equals(tActiveCustomerPostAct));
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tActiveCustomerPreAct.username,
        ),
        equals(tActiveCustomerPostAct),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) => customer.username == tActiveCustomerPreAct.username,
            )
            .creditor,
        equals(tActiveCustomerPostAct.creditor),
      );
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tTargetCustomerPreAct.username,
        ),
        equals(tTargetCustomerPostAct),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) => customer.username == tTargetCustomerPreAct.username,
            )
            .debtor,
        equals(tTargetCustomerPostAct.debtor),
      );
      expect(atm.history.length, tAtm.history.length + 3);
      expect(atm.history.last, contains('balance now'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('transfer'),
      );
      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains(tCommand),
      );
    });
  });
}
