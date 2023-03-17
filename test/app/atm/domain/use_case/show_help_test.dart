import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/app/atm/domain/use_case/show_help.dart';
import 'package:atm_simulator/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'show_help_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AtmRepository>()])
void main() {
  late ShowHelp useCase;
  late MockAtmRepository mockAtmRepository;

  setUp(() {
    mockAtmRepository = MockAtmRepository();
    useCase = ShowHelp(repository: mockAtmRepository);
  });

  final tAtm =
      Atm(customers: const [], history: const [], updatedAt: DateTime.now());

  test('ShowHelp should get [Atm] from the repository', () async {
    // Arrange
    when(
      mockAtmRepository.showHelp(
        command: anyNamed('command'),
        atm: anyNamed('atm'),
      ),
    ).thenAnswer((_) async => Left(tAtm));

    // Act
    final result = await useCase(AtmParams(command: 'command', atm: tAtm));

    // Assert
    expect(result, Left(tAtm));
    verify(mockAtmRepository.showHelp(command: 'command', atm: tAtm));
    verifyNoMoreInteractions(mockAtmRepository);
  });
}
