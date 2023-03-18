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

  group('showHelp', () {
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
should return Left(Atm) where
  - atm.activeCustomer is same as passed atm.activeCustomer argument,
  - atm.customers is same as passed atm.customers argument,
  - atm.history has 2 new history items,
  - last history item contains word 'login' and 'logout' and 'balance' and 'deposit' and 'withdraw' and 'transfer' and 'help' and 'clear',
  - second last history item contains word 'help',
  if clear command successfully done''', () async {
      // Arrange
      final tAtm = newAtm();

      // Act
      final result = await repository.showHelp(atm: tAtm);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      final atm = left.value;

      expect(atm.activeCustomer, tAtm.activeCustomer);
      expect(atm.customers, tAtm.customers);
      expect(atm.history.length, tAtm.history.length + 2);
      expect(atm.history.last.toLowerCase(), contains('login'));
      expect(atm.history.last.toLowerCase(), contains('logout'));
      expect(atm.history.last.toLowerCase(), contains('balance'));
      expect(atm.history.last.toLowerCase(), contains('deposit'));
      expect(atm.history.last.toLowerCase(), contains('withdraw'));
      expect(atm.history.last.toLowerCase(), contains('transfer'));
      expect(atm.history.last.toLowerCase(), contains('clear'));
      expect(atm.history.last.toLowerCase(), contains('help'));
      expect(
        atm.history[atm.history.length - 2].toLowerCase(),
        contains('help'),
      );
    });
  });
}
