import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/app/atm/domain/use_case/log_in.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'log_in_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AtmRepository>()])
void main() {
  late LogIn useCase;
  late MockAtmRepository mockAtmRepository;

  setUp(() {
    mockAtmRepository = MockAtmRepository();
    useCase = LogIn(repository: mockAtmRepository);
  });

  const tAtm = Atm(customers: [], history: []);
  const tCommand = 'login irwan 123456';

  test('LogIn should get [Atm] from the repository', () async {
    // Arrange
    when(
      mockAtmRepository.logIn(
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
    verify(mockAtmRepository.logIn(command: tCommand, atm: tAtm));
    verifyNoMoreInteractions(mockAtmRepository);
  });
}
