import 'package:atm_simulator/app/atm/data/repository/atm_repository_impl.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
import 'package:atm_simulator/core/const/exception_const.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/util/pin_encrypter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'atm_repository_impl_log_in_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PinEncrypter>()])
void main() {
  late AtmRepositoryImpl repository;
  late MockPinEncrypter mockPinEncrypter;

  setUp(() {
    mockPinEncrypter = MockPinEncrypter();
    repository = AtmRepositoryImpl(pinEncrypter: mockPinEncrypter);
  });

  group('logIn', () {
    const tUsername = 'irwan';
    const tPin = '123456';
    const tValidCommand = 'login $tUsername $tPin';

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
        'should return Right(AppException) with specific message if current customer is already logged in',
        () async {
      // Arrange
      const tCommand = tValidCommand;
      const tMessage = loginAlreadyLoggedIn;
      final tAtm = newAtmWithActiveCustomer();

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if command argument is not consists of 3 words',
        () async {
      // Arrange
      const tCommand = 'login';
      const tMessage = loginInvalidParams;
      final tAtm = newAtm();

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if username contains spaces or special characters',
        () async {
      // Arrange
      const tCommand = 'login irwan& 123456';
      const tMessage = loginInvalidUsername;
      final tAtm = newAtm();

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if pin is not numeric',
        () async {
      // Arrange
      const tCommand = 'login irwan a23456';
      const tMessage = loginPinMustNumeric;
      final tAtm = newAtm();

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if pin is not 6 digits',
        () async {
      // Arrange
      const tCommand = 'login irwan 1234';
      const tMessage = loginPinMustSixDigits;
      final tAtm = newAtm();

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if customer is found but pin is not match',
        () async {
      // Arrange
      when(mockPinEncrypter.comparePin(any, any)).thenAnswer((_) => false);

      const tCommand = 'login irwan 123457';
      const tMessage = loginPinNotMatch;
      final tAtm = newAtm(customers: [tCustomer]);

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
should return Left(Atm) where
  - atm.activeCustomer is not null,
  - atm.activeCustomer has same data from passed command argument,
  - atm.customers is same as passed atm.customers argument,
  - atm.history has 3 new history items,
  - last history item contains word 'balance',
  - second last history item contains word 'welcome back',
  - third last history item value is same as passed command,
  if login successfully done''', () async {
      // Arrange
      when(mockPinEncrypter.comparePin(any, any)).thenAnswer((_) => true);

      const tCommand = tValidCommand;
      final tAtm = newAtm(customers: [tCustomer]);

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(atm.activeCustomer, equals(tCustomer));
      expect(atm.customers, tAtm.customers);
      expect(atm.history.length, tAtm.history.length + 3);
      expect(atm.history.last.toLowerCase(), contains('balance'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('welcome back'),
      );
      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains(tCommand),
      );
    });

    test('''
should register new customer if username not found and return Left(Atm) where
  - atm.activeCustomer is not null,
  - atm.activeCustomer has same data from passed command argument,
  - atm.customers 1 new item,
  - last customer in atm.customers has same data as atm.activeCustomer,
  - atm.history has 3 new history items,
  - last history item contains word 'balance' and '0',
  - second last history item contains word 'hello',
  - third last history item value is same as passed command argument,
  if login successfully done''', () async {
      // Arrange
      when(mockPinEncrypter.encrypt(any)).thenAnswer((_) => tPin);

      const tCommand = tValidCommand;
      final tAtm = newAtm();

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtm);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, isNotNull);
      expect(
        atm.activeCustomer,
        equals(const Customer(username: tUsername, pin: tPin, balance: 0)),
      );
      expect(atm.customers.length, tAtm.customers.length + 1);
      expect(atm.customers.last, atm.activeCustomer);
      expect(atm.history.length, tAtm.history.length + 3);
      expect(atm.history.last.toLowerCase(), contains('balance'));
      expect(atm.history.last.toLowerCase(), contains('0'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('hello'),
      );
      expect(
        atm.history[atm.history.length - 3].toLowerCase(),
        contains(tCommand),
      );
    });
  });
}
