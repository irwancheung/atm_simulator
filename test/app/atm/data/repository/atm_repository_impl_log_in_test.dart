import 'package:atm_simulator/app/atm/data/model/atm_model.dart';
import 'package:atm_simulator/app/atm/data/model/customer_model.dart';
import 'package:atm_simulator/app/atm/data/repository/atm_repository_impl.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
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

  group('logIn', () {
    const tUsername = 'irwan';
    const tPin = '123456';
    const tValidCommand = 'login $tUsername $tPin';

    final now = DateTime.now();
    final tAtmModel = AtmModel(
      customers: const [],
      history: const [],
      updatedAt: now,
    );

    test(
        'should return Right(AppException) with specific message if command argument is not consists of 3 words',
        () async {
      // Arrange
      const tCommand = 'login';
      const tMessage = invalidParams;

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if username contains spaces or special characters',
        () async {
      // Arrange
      const tCommand = 'login irwan& 123456';
      const tMessage = invalidUsername;

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if pin is not numeric',
        () async {
      // Arrange
      const tCommand = 'login irwan a23456';
      const tMessage = pinMustNumeric;

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if pin is not 6 digits',
        () async {
      // Arrange
      const tCommand = 'login irwan 1234';
      const tMessage = pinMustSixDigits;

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if current customer is still logged in',
        () async {
      // Arrange
      const tCommand = tValidCommand;
      const tMessage = alreadyLoggedIn;

      final tAtmModel2 = tAtmModel.copyWith(
        activeCustomer: CustomerModel(
          username: tUsername,
          pin: pinEncrypter.encrypt(tPin),
          balance: 0,
        ),
      );

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel2);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test(
        'should return Right(AppException) with specific message if customer is found but pin is not match',
        () async {
      // Arrange
      const tCommand = 'login irwan 123457';
      const tMessage = pinNotMatch;
      final tAtmModel2 = tAtmModel.copyWith(
        customers: [
          CustomerModel(
            username: tUsername,
            pin: pinEncrypter.encrypt(tPin),
            balance: 0,
          )
        ],
      );

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel2);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
should return Left(Atm) where
  - atm.activeCustomer is not null,
  - atm.activeCustomer has same data from command,
  - atm.updatedAt has latest datetime compared to passed AtmModel argument,
  if login successful''', () async {
      // Arrange
      const tCommand = tValidCommand;
      final tAtmModel2 = tAtmModel.copyWith(
        customers: [
          CustomerModel(
            username: tUsername,
            pin: pinEncrypter.encrypt(tPin),
            balance: 0,
          )
        ],
      );

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel2);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      expect(left.value.activeCustomer, isNotNull);
      expect(left.value.activeCustomer!.username, tUsername);
      expect(left.value.activeCustomer!.pin, pinEncrypter.encrypt(tPin));
      expect(left.value.updatedAt.isAfter(tAtmModel.updatedAt), true);
    });

    test('''
should register new customer if username not found and return Left(Atm) where
  - atm.activeCustomer is not null,
  - atm.activeCustomer has same data from command
  - total atm.customers increases by one
  - atm.updatedAt has latest datetime compared to passed AtmModel argument,
  if login successful''', () async {
      // Arrange
      const tCommand = tValidCommand;

      // Act
      final result = await repository.logIn(command: tCommand, atm: tAtmModel);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      expect(left.value.activeCustomer, isNotNull);
      expect(left.value.activeCustomer!.username, tUsername);
      expect(left.value.activeCustomer!.pin, pinEncrypter.encrypt(tPin));
      expect(left.value.customers.length, tAtmModel.customers.length + 1);
      expect(left.value.updatedAt.isAfter(tAtmModel.updatedAt), true);
    });
  });
}
