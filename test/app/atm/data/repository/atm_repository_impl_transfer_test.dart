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

  group('transfer', () {
    const tUsername = 'irwan';
    const tPin = '123456';
    const tValidCommand = 'transfer cindy 100000';

    const tActiveCustomer = Customer(
      username: tUsername,
      pin: tPin,
      balance: 1000000,
    );

    const tTargetCustomer = Customer(
      username: 'cindy',
      pin: tPin,
      balance: 1000000,
    );

    const tAtm = Atm(
      customers: [tActiveCustomer, tTargetCustomer],
      history: [],
    );

    const tAtmLoggedIn = Atm(
      activeCustomer: tActiveCustomer,
      customers: [tActiveCustomer, tTargetCustomer],
      history: [],
    );

    test(
        'should return Right(AppException) with specific message if customer is not logged in yet',
        () async {
      // Arrange
      const tCommand = tValidCommand;
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

      // Act
      final result =
          await repository.transfer(command: tCommand, atm: tAtmLoggedIn);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is not a number',
        () async {
      // Arrange
      const tCommand = 'transfer cindy 100a';
      const tMessage = transferInvalidAmount;

      // Act
      final result =
          await repository.transfer(command: tCommand, atm: tAtmLoggedIn);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is not a positive number',
        () async {
      // Arrange
      const tCommand = 'transfer cindy -100';
      const tMessage = transferInvalidAmount;

      // Act
      final result =
          await repository.transfer(command: tCommand, atm: tAtmLoggedIn);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if target customer is not found',
        () async {
      // Arrange
      const tCommand = 'transfer hendra 100';
      const tMessage = transferTargetNotFound;

      // Act
      final result =
          await repository.transfer(command: tCommand, atm: tAtmLoggedIn);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if target customer is the same as active customer',
        () async {
      // Arrange
      const tCommand = 'transfer irwan 100';
      const tMessage = transferSameAccount;

      // Act
      final result =
          await repository.transfer(command: tCommand, atm: tAtmLoggedIn);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
with amount less equal to balance should return Left(Atm) where
  - atm.activeCustomer is not null,
  - atm.activeCustomer.balance is decreased by amount,
  - targetCustomer.balance is increased by amount,
  - atm.customers is updated with new activeCustomer and new targetCustomer,
  - atm.history has 3 new history items,
  - last history item contains word 'balance now',
  - second last history item contains word 'transferred',
  - third last history item contains word from command argument,
if transfer successfully done''', () async {
      // Arrange
      const tCommand = tValidCommand;
      const tAmount = 100000;
      final tActiveCustomerNewBalance = tActiveCustomer.balance - tAmount;
      final tTargetCustomerNewBalance = tTargetCustomer.balance + tAmount;

      // Act
      final result =
          await repository.transfer(command: tCommand, atm: tAtmLoggedIn);

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
        atm.activeCustomer,
      );
      expect(
        atm.customers
            .firstWhere(
              (customer) => customer.username == tTargetCustomer.username,
            )
            .balance,
        tTargetCustomerNewBalance,
      );
      expect(atm.history.length, tAtmLoggedIn.history.length + 3);
      expect(atm.history.last.contains('balance now'), true);
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
