import 'dart:convert';
import 'package:crypto/crypto.dart';

// md5 加密
String generateMd5(String data) {
  List<int>content = const Utf8Encoder().convert(data);
  Digest digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  return digest.toString();
}