import 'dart:convert' show base64Url;

import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class EncryptRepository {
  //for AES Algorithms
  static Encrypted? encrypted;
  static var decrypted;

  //for Fernet Algorithms
  static Encrypted? fernetEncrypted;
  static var fernetDecrypted;

  static encryptAES(plainText) {
    final key = Key.fromUtf8('TestString1234??');
    final iv = IV.fromLength(16);
    final encryptor = Encrypter(AES(key));
    encrypted = encryptor.encrypt(plainText, iv: iv);
    if (kDebugMode) {
      print("encryptAES: ${encrypted!.base64}");
    }
    return encrypted;
  }

  static decryptAES(plainText) {
    final key = Key.fromUtf8('TestString1234??');
    final iv = IV.fromLength(16);
    final encryptor = Encrypter(AES(key));
    decrypted = encryptor.decrypt(encrypted!, iv: iv);
    if (kDebugMode) {
      print(decrypted);
    }
    return decrypted;
  }

  static encryptFernet(plainText) {
    final key = Key.fromUtf8('ZmDfcTF7_60GrrY167zsiPd67pEvs0aGOv2oasOM1Pg=');
    final iv = IV.fromLength(16);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    final encryptor = Encrypter(fernet);
    fernetEncrypted = encryptor.encrypt(plainText, iv: iv);
    if (kDebugMode) {
      print(fernetEncrypted!.base64);
      // random cipher text
      print(fernet.extractTimestamp(fernetEncrypted!.bytes));
    }
  }

  static decryptFernet(plainText) {
    final key = Key.fromUtf8('ZmDfcTF7_60GrrY167zsiPd67pEvs0aGOv2oasOM1Pg=');
    final iv = IV.fromLength(16);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    final encryptor = Encrypter(fernet);
    fernetDecrypted = encryptor.decrypt(fernetEncrypted!, iv: iv);
    if (kDebugMode) {
      print(fernetDecrypted);
    }
  }
}
