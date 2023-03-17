import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/app/atm/domain/use_case/check_balance.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_balance_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AtmRepository>()])
void main() {
  late CheckBalance useCase;
  late MockAtmRepository mockAtmRepository;

  setUp(() {
    mockAtmRepository = MockAtmRepository();
    useCase = CheckBalance(repository: mockAtmRepository);
  });

  final tAtm =
      Atm(customers: const [], history: const [], updatedAt: DateTime.now());

  test('CheckBalance should get [Atm] from the repository', () async {
    // Arrange
    when(
      mockAtmRepository.checkBalance(
        command: anyNamed('command'),
        atm: anyNamed('atm'),
      ),
    ).thenAnswer((_) async => Left(tAtm));

    // Act
    final result = await useCase(AtmParams(command: 'command', atm: tAtm));

    // Assert
    expect(result, Left(tAtm));
    verify(mockAtmRepository.checkBalance(command: 'command', atm: tAtm));
    verifyNoMoreInteractions(mockAtmRepository);
  });
}
