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

  group('logOut', () {
    final now = DateTime.now();
    final tAtmModel = AtmModel(
      customers: const [],
      history: const [],
      updatedAt: now,
    );

    test(
        'should return Right(AppException) with specific message if atm.activeCustomer is null',
        () async {
      // Arrange
      const tMessage = alreadyLoggedOut;

      // Act
      final result = await repository.logOut(atm: tAtmModel);

      // Assert
      expect(result, const Right(AppException(tMessage)));
    });

    test('''
should return Left(Atm) where
  - atm.activeCustomer is null
  - atm.updatedAt has latest datetime compared to passed AtmModel argument,
  if login successful''', () async {
      // Arrange
      final tAtmModel2 = tAtmModel.copyWith(
        activeCustomer: CustomerModel(
          username: 'username',
          pin: pinEncrypter.encrypt('123456'),
          balance: 0,
        ),
      );

      // Act
      final result = await repository.logOut(atm: tAtmModel2);

      // Assert
      expect(result, isA<Left<Atm, AppException>>());

      final left = result as Left<Atm, AppException>;
      expect(left.value.activeCustomer, isNull);
      expect(left.value.updatedAt.isAfter(tAtmModel.updatedAt), true);
    });
  });
}
