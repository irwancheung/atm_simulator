import 'dart:convert';

import 'package:crypto/crypto.dart';

class PinEncrypter {
  String encrypt(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool comparePin(String pin, String encryptedPin) {
    return encrypt(pin) == encryptedPin;
  }
}
