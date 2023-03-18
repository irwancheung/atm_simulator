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

  group('withdraw', () {
    const tUsername = 'irwan';
    const tPin = '123456';
    const tValidCommand = 'withdraw 100000';

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
      const tMessage = withdrawNotLoggedIn;
      final tAtm = newAtm();

      // Act
      final result = await repository.withdraw(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if command argument is not consists of 2 words',
        () async {
      // Arrange
      const tCommand = 'withdraw';
      const tMessage = withdrawInvalidParams;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.withdraw(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is not a number',
        () async {
      // Arrange
      const tCommand = 'withdraw 20a00';
      const tMessage = withdrawInvalidAmount;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.withdraw(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if amount is zero or negative',
        () async {
      // Arrange
      const tCommand = 'withdraw -100000';
      const tMessage = withdrawInvalidAmount;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.withdraw(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if balance is insufficient',
        () async {
      const tCommand = 'withdraw 2000000';
      const tMessage = withdrawInsufficientBalance;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.withdraw(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
should return Left(Atm) where
  - atm.activeCustomer is not null,
  - atm.activeCustomer.balance is decreased by amount,
  - atm.customers is updated with new activeCustomer,
  - atm.history has 2 new history items,
  - last history item contains word 'balance now',
  - second last history item contains word from command argument,
  if deposit successfully done''', () async {
      // Arrange
      const tCommand = tValidCommand;
      const tAmount = 100000;
      final tAtm = newAtmWithActiveCustomer();
      final tActiveCustomerNewBalance = tCustomer.balance - tAmount;

      // Act
      final result = await repository.withdraw(command: tCommand, atm: tAtm);

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
  });
}
