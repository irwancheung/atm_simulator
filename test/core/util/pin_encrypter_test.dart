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
      const tCorrectPin = '1234';
      const tIncorrectPin = '1235';
      const tEncryptedCorrectPin =
          '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4';

      test('should return true if submitted pin is same as encrypted pin',
          () async {
        // Arrange
        const tpPin = tCorrectPin;

        // Act
        final result = pinEncrypter.comparePin(tpPin, tEncryptedCorrectPin);

        // Assert
        expect(result, true);
      });

      test('should return false if submitted pin is not same as encrypted pin',
          () async {
        // Arrange
        const tpPin = tIncorrectPin;

        // Act
        final result = pinEncrypter.comparePin(tpPin, tEncryptedCorrectPin);

        // Assert
        expect(result, false);
      });
    },
  );
}
