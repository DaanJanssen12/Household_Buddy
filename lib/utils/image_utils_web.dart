import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Converts an image file to Base64 (Web)
Future<String> convertImageToBase64(html.File imageFile) async {
  final reader = html.FileReader();
  reader.readAsArrayBuffer(imageFile);
  await reader.onLoad.first;
  Uint8List bytes = reader.result as Uint8List;
  return base64Encode(bytes);
}
