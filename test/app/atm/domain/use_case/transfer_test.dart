import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/app/atm/domain/use_case/transfer.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transfer_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AtmRepository>()])
void main() {
  late Transfer useCase;
  late MockAtmRepository mockAtmRepository;

  setUp(() {
    mockAtmRepository = MockAtmRepository();
    useCase = Transfer(repository: mockAtmRepository);
  });

  const tAtm = Atm(customers: [], history: []);
  const tCommand = 'transfer cindy 50000';

  test('Transfer should get [Atm] from the repository', () async {
    // Arrange
    when(
      mockAtmRepository.transfer(
        command: anyNamed('command'),
        atm: anyNamed('atm'),
      ),
    ).thenAnswer((_) async => const Left(tAtm));

    // Act
    final result = await useCase(
      const AtmParams(
        command: tCommand,
        atm: tAtm,
      ),
    );

    // Assert
    expect(result, const Left(tAtm));
    verify(
      mockAtmRepository.transfer(command: tCommand, atm: tAtm),
    );
    verifyNoMoreInteractions(mockAtmRepository);
  });
}
