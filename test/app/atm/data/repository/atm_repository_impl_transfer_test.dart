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
import 'package:sprintf/sprintf.dart';

void main() {
  late AtmRepositoryImpl repository;
  late PinEncrypter pinEncrypter;

  setUp(() {
    pinEncrypter = PinEncrypter();
    repository = AtmRepositoryImpl(pinEncrypter: pinEncrypter);
  });

  group('transfer', () {
    const tUsername1 = 'irwan';
    const tPin1 = '123456';
    const tBalance1 = 100000;

    const tCustomer1 = Customer(
      username: tUsername1,
      pin: tPin1,
      balance: tBalance1,
    );

    const tUsername2 = 'cindy';
    const tPin2 = '123456';
    const tBalance2 = 100000;

    const tCustomer2 = Customer(
      username: tUsername2,
      pin: tPin2,
      balance: tBalance2,
    );

    const tUsername3 = 'nana';

    const tAtm = Atm(
      customers: [tCustomer1, tCustomer2],
      history: [],
    );

    Atm newAtmWithActiveCustomer(Customer customer) {
      return tAtm.copyWith(activeCustomer: customer);
    }

    test(
        'should return Right(AppException) with specific message if customer is not logged in yet',
        () async {
      // Arrange
      const tCommand = 'transfer cindy 100';
      const tMessage = transferNotLoggedIn;

      // Act
      final result = await repository.transfer(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if command argument is not consists of 3 words',
        () async {
      // Arrange
      const tCommand = 'transfer cindy';
      const tMessage = transferInvalidParams;
      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tCustomer1);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is not a number',
        () async {
      // Arrange
      const tCommand = 'transfer cindy 100a';
      const tMessage = transferInvalidAmount;
      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tCustomer1);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is not a positive number',
        () async {
      // Arrange
      const tCommand = 'transfer cindy -100';
      const tMessage = transferInvalidAmount;
      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tCustomer1);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if target customer is not found',
        () async {
      // Arrange
      const tCommand = 'transfer hendra 100';
      const tMessage = transferTargetNotFound;
      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tCustomer1);
      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if target customer is the same as active customer',
        () async {
      // Arrange
      const tCommand = 'transfer irwan 100';
      const tMessage = transferSameAccount;
      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tCustomer1);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
with amount less than or equal to balance should return Left(Atm) where
  - activeCustomer is not null,
  - activeCustomer.balance is decreased by amount of transfer,
  - targetCustomer.balance is increased by amount of transfer,
  - customers is updated with new activeCustomer and new targetCustomer,
  - history has 3 new history items,
  - last history item contains word 'balance now',
  - second last history item contains word 'transferred',
  - third last history item contains word from command argument,
  if transfer successfully done''', () async {
      // Arrange
      const tAmount = 1000;
      const tCommand = 'transfer $tUsername2 $tAmount';
      final tActiveCustomerNewBalance = tCustomer1.balance - tAmount;
      final tTargetCustomerNewBalance = tCustomer2.balance + tAmount;

      final tActiveCustomer =
          tCustomer1.copyWith(balance: tActiveCustomerNewBalance);
      final tTargetCustomer =
          tCustomer2.copyWith(balance: tTargetCustomerNewBalance);
      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tCustomer1);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(atm.activeCustomer!.balance, tActiveCustomerNewBalance);
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tActiveCustomer.username,
        ),
        equals(atm.activeCustomer),
      );
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tTargetCustomer.username,
        ),
        equals(tTargetCustomer),
      );
      expect(atm.history.length, tAtmWithActiveCustomer.history.length + 3);
      expect(atm.history.last.toLowerCase(), contains('balance now'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('transferred'),
      );
      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains(tCommand),
      );
    });

    test(
        "should return Right(AppException) with specific message if activeCustomer's balance is lower than amount, activeCustomer.creditor is not null, and has different username to target customer",
        () async {
      // Arrange
      const tCommand = 'transfer $tUsername2 200000';
      final tActiveCustomer = tCustomer1.copyWith(
        creditor: const Creditor(username: tUsername3, amount: 100),
      );
      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tActiveCustomer);
      final tMessage =
          sprintf(transferCreditorIsDifferent, ['100', tUsername3]);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, Right(AppException(tMessage)));
    });

    test(
        "should return Right(AppException) with specific message if activeCustomer's balance is lower than amount, targetCustomer.debtor is not null, and has different username to active customer",
        () async {
      // Arrange
      const tCommand = 'transfer $tUsername2 200000';
      const tActiveCustomer = tCustomer1;

      final tAtmWithActiveCustomer = tAtm.copyWith(
        activeCustomer: tActiveCustomer,
        customers: [
          tActiveCustomer,
          tCustomer2.copyWith(
            debtor: const Debtor(username: tUsername3, amount: 100),
          ),
        ],
      );

      final tMessage = sprintf(transferDebtorIsDifferent, [tUsername2]);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, Right(AppException(tMessage)));
    });

    test('''
with amount less than or equal to balance while activeCustomer.creditor and targetCustomer.debtor is null should return Left(Atm) where
  - activeCustomer is not null,
  - all activeCustomer.balance amount is transferred to targetCustomer.balance,
  - create new creditor with target username and remaining amount,
  - create new debtor with active username and remaining amount,
  - customers is updated with new activeCustomer and new targetCustomer,
  - history has 4 new history items,
  - last history item contains word 'owed' and 'to',
  - second last history item contains word 'balance now',
  - third last history item contains word 'transferred',
  - fourth last history item contains word from command argument,
  if transfer successfully done''', () async {
      // Arrange
      const tAmount = 150000;
      const tCommand = 'transfer $tUsername2 $tAmount';
      final remainder = tAmount - tCustomer1.balance;

      const tActiveCustomerNewBalance = 0;
      final tTargetCustomerNewBalance = tCustomer2.balance + tCustomer1.balance;

      final tActiveCustomer = tCustomer1.copyWith(
        balance: tActiveCustomerNewBalance,
        creditor: Creditor(username: tUsername2, amount: remainder),
      );

      final tTargetCustomer = tCustomer2.copyWith(
        balance: tTargetCustomerNewBalance,
        debtor: Debtor(username: tUsername1, amount: remainder),
      );

      final tAtmWithActiveCustomer = newAtmWithActiveCustomer(tCustomer1);

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(atm.activeCustomer, equals(tActiveCustomer));
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tActiveCustomer.username,
        ),
        equals(tActiveCustomer),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) => customer.username == tActiveCustomer.username,
            )
            .creditor,
        equals(tActiveCustomer.creditor),
      );
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tTargetCustomer.username,
        ),
        equals(tTargetCustomer),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) => customer.username == tTargetCustomer.username,
            )
            .debtor,
        equals(tTargetCustomer.debtor),
      );
      expect(atm.history.length, tAtmWithActiveCustomer.history.length + 4);
      expect(atm.history.last.toLowerCase(), contains('owed'));
      expect(atm.history.last.toLowerCase(), contains('to'));
      expect(
        atm.history[atm.history.length - 2]
            .toLowerCase()
            .contains('balance now'),
        true,
      );
      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains('transferred'),
      );
      expect(
        atm.history[atm.history.length - 4].toLowerCase(),
        contains(tCommand),
      );
    });

    test('''
while balance is zero and activeCustomer.creditor and targetCustomer.debtor are not null should return Left(Atm) where
  - activeCustomer is not null,
  - all activeCustomer.balance amount is transferred to targetCustomer.balance,
  - update activeCustomer.creditor with latest amount,
  - update targetCustomer.debtor with latest amount,
  - customers is updated with new activeCustomer and new targetCustomer,
  - history has 4 new history items,
  - last history item contains word 'owed' and 'to',
  - second last history item contains word 'balance now',
  - third last history item contains word 'transferred',
  - fourth last history item contains word from command argument,
  if transfer successfully done''', () async {
      // Arrange
      const tAmount = 150000;
      const tCommand = 'transfer $tUsername2 $tAmount';
      final remainder = tAmount - tCustomer1.balance;

      const tActiveCustomerNewBalance = 0;
      final tTargetCustomerNewBalance = tCustomer2.balance + tCustomer1.balance;

      final tActiveCustomerPreAct = tCustomer1.copyWith(
        creditor: const Creditor(username: tUsername2, amount: 20000),
      );

      final tTargetCustomerPreAct = tCustomer2.copyWith(
        debtor: const Debtor(username: tUsername1, amount: 20000),
      );

      final tActiveCustomerPostAct = tCustomer1.copyWith(
        balance: tActiveCustomerNewBalance,
        creditor: Creditor(
          username: tUsername2,
          amount: tActiveCustomerPreAct.creditor!.amount + remainder,
        ),
      );

      final tTargetCustomerPostAct = tCustomer2.copyWith(
        balance: tTargetCustomerNewBalance,
        debtor: Debtor(
          username: tUsername1,
          amount: tTargetCustomerPreAct.debtor!.amount + remainder,
        ),
      );

      final tAtmWithActiveCustomer = tAtm.copyWith(
        activeCustomer: tActiveCustomerPreAct,
        customers: [tActiveCustomerPreAct, tTargetCustomerPreAct],
      );

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(atm.activeCustomer, equals(tActiveCustomerPostAct));
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tActiveCustomerPostAct.username,
        ),
        equals(tActiveCustomerPostAct),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) =>
                  customer.username == tActiveCustomerPostAct.username,
            )
            .creditor,
        equals(tActiveCustomerPostAct.creditor),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) =>
                  customer.username == tTargetCustomerPostAct.username,
            )
            .debtor,
        equals(tTargetCustomerPostAct.debtor),
      );
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tTargetCustomerPostAct.username,
        ),
        equals(tTargetCustomerPostAct),
      );
      expect(atm.history.length, tAtmWithActiveCustomer.history.length + 4);
      expect(atm.history.last.toLowerCase(), contains('owed'));
      expect(atm.history.last.toLowerCase(), contains('to'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('balance now'),
      );
      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains('transferred'),
      );
      expect(
        atm.history[atm.history.length - 4].toLowerCase(),
        contains(tCommand),
      );
    });

    test('''
while targetCustomer is same as debtor should return Left(Atm) where
  - activeCustomer is not null,
  - activeCustome.balance is decreased by amount of transfer,
  - activeCustomer.debtor.amount is decreased by amount of transfer,
  - targetCustomer.creditor.amount is decreased by amount of transfer,
  - if activeCustomer.debtor.amount is zero then activeCustomer.debtor is null,
  - if targetCustomer.creditor.amount is zero then targetCustomer.creditor is null,
  - customers is updated with new activeCustomer and new targetCustomer,
  - history has3 to 4 new history items,
  - If activeCustomer.debtor is not null, then last history item contains word 'owed' and 'from',
  - If activeCustomer.debtor is null, then last history item contains word 'balance now',
  - second last history item contains word 'transferred',
  - third last history item contains word from command argument,
  if transfer successfully done''', () async {
      // Arrange
      const tAmount = 20000;
      const tCommand = 'transfer $tUsername2 $tAmount';

      final tActiveCustomerPreAct = tCustomer1.copyWith(
        balance: 20000,
        debtor: const Debtor(username: tUsername2, amount: 20000),
      );

      final tTargetCustomerPreAct = tCustomer2.copyWith(
        balance: 0,
        creditor: const Creditor(username: tUsername1, amount: 20000),
      );

      final tActiveCustomerPostAct = Customer(
        username: tCustomer1.username,
        pin: tCustomer1.pin,
        balance: 20000,
      );

      final tTargetCustomerPostAct = Customer(
        username: tCustomer2.username,
        pin: tCustomer2.pin,
        balance: 0,
      );

      final tAtmWithActiveCustomer = tAtm.copyWith(
        activeCustomer: tActiveCustomerPreAct,
        customers: [tActiveCustomerPreAct, tTargetCustomerPreAct],
      );

      // Act
      final result = await repository.transfer(
        command: tCommand,
        atm: tAtmWithActiveCustomer,
      );

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(atm.activeCustomer, equals(tActiveCustomerPostAct));
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tActiveCustomerPostAct.username,
        ),
        equals(tActiveCustomerPostAct),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) =>
                  customer.username == tActiveCustomerPostAct.username,
            )
            .debtor,
        equals(null),
      );
      expect(
        atm.customers.firstWhere(
          (customer) => customer.username == tTargetCustomerPostAct.username,
        ),
        equals(tTargetCustomerPostAct),
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) =>
                  customer.username == tTargetCustomerPostAct.username,
            )
            .creditor,
        equals(null),
      );
      expect(atm.history.length, tAtmWithActiveCustomer.history.length + 3);
      expect(atm.history.last.toLowerCase(), contains('balance now'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('transferred'),
      );
      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains(tCommand),
      );
    });
  });
}
