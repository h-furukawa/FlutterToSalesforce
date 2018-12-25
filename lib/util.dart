import "dart:math";
import 'dart:convert';

class Util {
  /// ランダムな文字列を生成
  static String randomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;

    final rand = new Random.secure();
    final codeUnits = new List.generate(
      length,
          (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return new String.fromCharCodes(codeUnits);
  }

  /// =を消したBase64エンコードを行う
  static String base64UrlEncode(String value) {
    String encodeValue = base64Url.encode(value.codeUnits);
    while(encodeValue.endsWith("=")) {
      encodeValue = encodeValue.substring(0, encodeValue.length - 1);
    }
    return encodeValue;
  }
}