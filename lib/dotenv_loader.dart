import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadEnvVariables() async {
  // Load .env file without treating it as an asset
  await dotenv.load(fileName: ".env");
}
