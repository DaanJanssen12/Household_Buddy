import 'package:flutter/foundation.dart' show kIsWeb;

/// Uses the correct image utility file based on platform
export 'image_utils_io.dart' if (kIsWeb) 'image_utils_web.dart';
