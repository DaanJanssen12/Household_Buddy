import 'dart:io';
import 'dart:convert';

/// Converts an image file to Base64 (Mobile/Desktop)
Future<String> convertImageToBase64(File imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes();
  return base64Encode(imageBytes);
}
