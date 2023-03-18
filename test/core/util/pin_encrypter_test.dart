import 'package:atm_simulator/core/util/pin_encrypter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PinEncrypter pinEncrypter;

  setUp(() => pinEncrypter = PinEncrypter());

  group('encrypt', () {
    test('should return encrypted string when successfully encrypt pin',
        () async {
      // Arrange
      const tPin = '1234';
      const tEncryptedPin =
          '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4';

      // Act
      final result = pinEncrypter.encrypt(tPin);

      // Assert
      expect(result, tEncryptedPin);
    });
  });

  group(
    'comparePin',
    () {
      const tInputPin = '1234';
      const tTargetPin = '5678';

      test('should return true if passed pin is same as encrypted pin',
          () async {
        // Arrange
        const tpPin = tInputPin;

        // Act
        final result =
            pinEncrypter.comparePin(tpPin, pinEncrypter.encrypt(tInputPin));

        // Assert
        expect(result, true);
      });

      test('should return false if passed pin is not same as encrypted pin',
          () async {
        // Arrange
        const tpPin = tInputPin;

        // Act
        final result =
            pinEncrypter.comparePin(tpPin, pinEncrypter.encrypt(tTargetPin));

        // Assert
        expect(result, false);
      });
    },
  );
}
