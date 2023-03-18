import 'package:atm_simulator/app/atm/data/repository/atm_repository_impl.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
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

  group('clearCommands', () {
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

    test('''
without logged in should return Left(Atm) where
  - atm.activeCustomer is same as passed atm.activeCustomer argument,
  - atm.customers is same as passed atm.customers argument,
  - atm.history length should be 2,
  - last history item contains word 'type',
  - second last history item contains word 'welcome',
  if clear command successfully done''', () async {
      // Arrange
      final tAtm = newAtm();

      // Act
      final result = await repository.clearCommands(atm: tAtm);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, tAtm.activeCustomer);
      expect(atm.customers, tAtm.customers);
      expect(atm.history.length, 2);
      expect(atm.history.last.toLowerCase(), contains('type'));
      expect(atm.history.first.toLowerCase(), contains('welcome'));
    });

    test('''
when logged in should return Left(Atm) where
  - atm.activeCustomer is same as passed atm.activeCustomer argument,
  - atm.customers is same as passed atm.customers argument,
  - atm.history should be empty,
  if clear command successfully done''', () async {
      // Arrange
      final tAtmModel2 = newAtm(
        activeCustomer: Customer(
          username: 'username',
          pin: pinEncrypter.encrypt('123456'),
          balance: 10000,
        ),
      );

      // Act
      final result = await repository.clearCommands(atm: tAtmModel2);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, tAtmModel2.activeCustomer);
      expect(atm.customers, tAtmModel2.customers);
      expect(atm.history.length, 0);
    });
  });
}
