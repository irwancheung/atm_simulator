import 'package:atm_simulator/core/util/number_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toDollar', () {
    test(
        'should return String with format : Rp[space]numeric_value_with_thousand_separator',
        () async {
      // Arrange
      const tNumber = 100000000;

      // Act
      final result = tNumber.toDollar();

      // Assert
      expect(result, '\$100,000,000');
    });
  });
}
