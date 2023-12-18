import 'package:crypto/crypto.dart';
import 'dart:convert';

class Hashing {
  static String hash(String toBeHashed) {
    var bytesToHash = utf8.encode(toBeHashed);
    var sha256Digest = sha256.convert(bytesToHash);

    final hashed = sha256Digest.toString(); //do hashing
    return hashed;
  }
}
