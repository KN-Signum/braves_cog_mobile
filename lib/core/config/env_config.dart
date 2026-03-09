import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  static bool get useMockData {
    return dotenv.env['USE_MOCK_DATA']?.toLowerCase() == 'true';
  }

  static String get apiBaseUrl {
    // Default to dev URL if not specified
    final env = dotenv.env['APP_ENV'] ?? 'dev';
    if (env == 'prod') {
      return dotenv.env['API_BASE_URL_PROD'] ?? '';
    }
    return dotenv.env['API_BASE_URL_DEV'] ?? '';
  }
}
