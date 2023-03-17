import 'package:atm_simulator/app/atm/data/model/atm_model.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tAtmModel = AtmModel(
    customers: const [],
    history: const [],
    updatedAt: DateTime.now(),
  );

  test('tAtmModel should be a subclass of Atm entity', () {
    expect(tAtmModel, isA<Atm>());
  });
}
